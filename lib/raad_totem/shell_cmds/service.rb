module RaadTotem
  module ShellCmds
    class Service < Totem::ShellCmds::Base
      def run
        case @args[0]
        when 'start' then start(@args[1])
        when 'stop' then stop(@args[1])
        when 'run' then run(@args[1])
        when 'new' then new_s(@args[1])
        else
          puts_usage
        end
      end

      def start(service)
        return false unless require_arg(service, :service)
      end

      def stop(service)
        return false unless require_arg(service, :service)
      end

      def run(service)
        return false unless require_arg(service, :service)
      end

      def new_s(service)
        return false unless require_arg(service, :service)
      end

      private

      def puts_usage
        puts "Usage:\n  bundle exec totem service <command>"
        puts
        puts "Commands:\n"
        puts "  start <service> - Start service in the background."
        puts "  stop <service>  - Stop service running in the background."
        puts "  run <service>   - Run service in the foreground."
        puts "  new <service>   - Create a new service."
      end

      def puts_error(message)
          puts "ERROR: #{message}"
          puts
          puts_usage
      end

      def require_arg(val, name)
        if val.nil? || val.length == 0
          puts_error("You must provide a #{name}.")
          return false
        end

        return true
      end
    end
  end
end

Totem::Shell.register_cmd(:service, RaadTotem::ShellCmds::Service)
