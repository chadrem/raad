require 'optparse'
require 'timeout'
require 'thread'

module RaadTotem
  class Runner
    include Daemonizable

    SECOND = 1
    STOP_TIMEOUT = 60 * SECOND

    attr_accessor :pid_file

    # Create a new Runner
    #
    # @param argv [Array] command line arguments
    # @param service_class [Class] service class
    def initialize(argv, service_class)
      @argv = argv.dup # lets keep a copy for jruby double-launch
      @service_class = service_class
      @parsed_options = nil

      @stop_lock = Mutex.new
      @stop_signaled = false

      # parse command line options and set @parsed_options
      options_parser = service_class.respond_to?(:options_parser) ? service_class.options_parser(create_options_parser, RaadTotem.custom_options) : create_options_parser
      begin
        options_parser.parse!(argv)
      rescue OptionParser::InvalidOption => e
        puts(">> #{e.message}")
        exit!(false)
      end

      # grab what's left after options, which should be the start/stop command
      @parsed_options[:command] = argv[0].to_s.downcase
      unless ['start', 'stop', 'post_fork'].include?(@parsed_options[:command])
        puts(">> start|stop command is required")
        exit!(false)
      end

      # default service name
      @service_name = @parsed_options[:name] || default_service_name(service_class)

      # @pid_file is required to become Daemonizable
      @pid_file = @parsed_options.delete(:pid_file) || "./#{@service_name}.pid"

      # default stop timeout
      @stop_timeout = (@parsed_options.delete(:stop_timeout) || STOP_TIMEOUT).to_i
    end

    def run
      # check for stop command, @pid_file must be set
      if @parsed_options[:command] == 'stop'
        puts(">> RaadTotem service wrapper v#{VERSION} stopping")
        # first send the TERM signal which will invoke the daemon wait_or_will method which will timeout after @stop_timeout
        # if still not stopped afer @stop_timeout + 2 seconds, KILL -9 will be sent.
        success = send_signal('TERM', @stop_timeout + (2 * SECOND))
        exit(success)
      end

      Dir.chdir(File.expand_path(File.dirname("./"))) unless RaadTotem.test?

      if @parsed_options[:command] == 'post_fork'
        # we've been spawned and re executed, finish setup
        post_fork_setup(@service_name, @parsed_options[:redirect])
        start_service
      else
        puts(">> RaadTotem service wrapper v#{VERSION} starting")
        @parsed_options[:daemonize] ? daemonize(@argv, @service_name, @parsed_options[:redirect]) {start_service} : start_service
      end
    end

    private

    def start_service
      Totem.logger.debug("initializing #{@service_name} service")

      # create service instance
      service = @service_class.new

      # important to display this after service instantiation.
      Totem.logger.info("starting #{@service_name} service")

      at_exit do
        Totem.logger.info(">> RaadTotem service wrapper stopped")
      end

      # do not trap :QUIT because its not supported in jruby
      [:INT, :TERM].each{|sig| SignalTrampoline.trap(sig) {stop_service(service)}}

      # launch the service thread and call start. we expect start not to return
      # unless it is done or has been stopped.
      service_thread = Thread.new do
        Thread.current.abort_on_exception = true
        service.start
        stop_service(service)
      end

      result = wait_or_kill(service_thread)
      # if not daemonized start a sentinel thread, if still alive after 2 seconds, do arakiri
      Thread.new{sleep(2 * SECOND);  Process.kill(:KILL, Process.pid)} unless @parsed_options[:daemonize]
      # use exit and not exit! to make sure the at_exit hooks are called, like the pid cleanup, etc.
      exit(result)
    end

    def stop_service(service)
      return if @stop_lock.synchronize{s = @stop_signaled; @stop_signaled = true; s}

      Totem.logger.info("stopping #{@service_name} service")
      service.stop if service.respond_to?(:stop)
      RaadTotem.stopped = true
    end

    # try to do a timeout join periodically on the given thread. if the join succeed then the stop
    # sequence is successful and return true.
    # Otherwise, on timeout if stop has beed signaled, wait a maximum of @stop_timeout on the
    # thread and kill it if the timeout is reached and return false in that case.
    #
    # @return [Boolean] true if the thread normally terminated, false if a kill was necessary
    def wait_or_kill(thread)
      while thread.join(SECOND).nil?
        # the join has timed out, thread is still buzzy.
        if @stop_lock.synchronize{@stop_signaled}
          # but if stop has been signalled, start "the final countdown" ♫
          try = 0; join = nil
          while (try += 1) <= @stop_timeout && join.nil? do
            join = thread.join(SECOND)
            Totem.logger.debug("waiting for service to stop #{try}/#{@stop_timeout}") if join.nil?
          end
          if join.nil?
            Totem.logger.error("stop timeout exhausted, killing service thread")
            thread.kill
            return false
          end
          return true
        end
      end
      true
    end

    # convert the service class name from CameCase to underscore
    #
    # @return [String] underscored service class name
    def default_service_name(clazz)
      clazz.to_s.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase!
    end

    # Create the options parser
    #
    # @return [OptionParser] Creates the options parser for the runner with the default options
    def create_options_parser
      @parsed_options ||= {
        :daemonize => false,
        :verbose => false,
      }

      options_parser ||= OptionParser.new do |opts|
        opts.banner = "USAGE: ruby <service>.rb [options] start|stop"

        opts.separator ""
        opts.separator "Service Options:"

        opts.on('-c', '--config FILE', "config file (default: ./config/<service>.rb)") { |v| @parsed_options[:config] = v }
        opts.on('-d', '--daemonize', "run daemonized in the background (default: #{@parsed_options[:daemonize]})") { |v| @parsed_options[:daemonize] = v }
        opts.on('-P', '--pid FILE', "pid file when daemonized (default: <service>.pid)") { |file| @parsed_options[:pid_file] = file }
        opts.on('-r', '--redirect FILE', "redirect stdout to FILE when daemonized (default: no)") { |v| @parsed_options[:redirect] = v }
        opts.on('-n', '--name NAME', "daemon process name (default: <service>)") { |v| @parsed_options[:name] = v }
        opts.on('--timeout SECONDS', "seconds to wait before force stopping the service (default: 60)") { |v| @parsed_options[:stop_timeout] = v }
        opts.on('--ruby opts', "daemonized ruby interpreter specifc options") { |v| RaadTotem.ruby_options = v }

        opts.on('-h', '--help', 'display help message') { show_options(options_parser) }
      end

      options_parser
    end

    # Output the servers options and exit Ruby
    #
    # @param opts [OptionsParser] The options parser
    def show_options(opts)
      puts(opts)
      exit!(false)
    end

  end
end
