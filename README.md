# Raad - Totem

This gem allows you to easily create daemons (also known as servers, services, or background processes) in a project generated with [Totem](https://github.com/chadrem/totem).  Both MRI and Jruby are supported.

This is a fork of the [Raad](https://github.com/colinsurprenant/raad) gem that is modified for Totem projects.  All credit goes to the original project as they did all the hard work.

## Changes from the original Raad v0.5.0:

- Removal of log4j since Totem already has a built in logger.
- Integration with Totem's environment setting.

## Installation

Add this line to your application's Gemfile:

    gem 'raad-totem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install raad-totem

## Usage

Coming soon.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
