# Raad - Totem

This gem allows you to easily create daemons (also known as servers, services, or background processes) in a project generated with [Totem](https://github.com/chadrem/totem).  Both MRI and Jruby are supported.

This is a fork of the [Raad](https://github.com/colinsurprenant/raad) gem that is modified for Totem projects.  All credit goes to the original project as they did all the hard work.

## Changes from the original Raad v0.5.0:

- Removal of log4j since Totem already has a built in logger.
- Integration with Totem.
- Change namespaces so as not to conflict with Raad if both gems are installed.
- Removal of various command line options and use Totem defaults instead.

## Installation

Add this line to your Totem project's Gemfile:

    gem 'raad_totem', :require => 'raad_totem/shell_cmds/service'

And then execute:

    $ bundle

## Usage

Create a new service file `service/hello_world_service.rb` in the project root directory:

    #!/usr/bin/env ruby

    require_relative '../config/environment.rb'

    require 'raad_totem'

    class HelloWorldService
      def self.options_parser(parser, options)
        parser.separator('')
        parser.separator('App Options:')

        parser.on('-c', '--custom', 'Some custom option') {|val| options[:custom] = val }

        return parser
      end

      def start
        Totem.logger.info('Service start.')

        while !RaadTotem.stopped?
          Totem.logger.info('Hello World.')
          sleep 5
        end
      end

      def stop
        Totem.logger.info('Service stop.')
      end
    end
    
Make sure you set executable permissions on your service file:

    chmod +x service/hello_world_service.rb

You can run your service in the foreground (press ctrl+c to kill it and wait a few seconds):

    ./service/hello_world_service.rb start

You can also run your service in the background:

    ./service/hello_world_service.rb -d start

To stop the background service:

    ./service/hello_world_service.rb stop

By default, your service will log to a custom log in the `log` directory.
It will also create a PID file in the `tmp/pid` directory.

To view all available options (including custom ones you define):

    ./service/hello_world_service.rb --help

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
