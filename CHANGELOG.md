# 0.0.1 03-14-2014
- Fork project and name it raad_totem.
- From this point forward, this Changelog will not be updated.  Read git log instead.

# 0.3.1, 08-24-2011
- initial release. support for MRI 1.8 & 1.9 only

# 0.3.3, 08-26-2011
- reworked runner stop sequence & signals trapping
- force kill + pid removal bug
- wrong exit code bug
- comments & cosmetics

# 0.4.0, 09-13-2011
- using SignalTrampoline for safe signal handling
- JRuby support
- specs and validations for all supported rubies
- tested on MRI 1.8.7 & 1.9.2, REE 1.8.7, JRuby 1.6.4 under OSX 10.6.8 and Linux Ubuntu 10.04

# 0.4.1, 09-22-2011
- issue #1, allow arbitrary environment name, https://github.com/praized/raad/issues/1
- issue #3, avoid calling stop multiple times,  https://github.com/praized/raad/issues/3
- added Raad.stopped?

# 0.5.0, 10-12-2011
- issue #4, allow logger usage in service initialize method, https://github.com/praized/raad/issues/4
- issue #7, Raad.env not correct in service.initialize, https://github.com/praized/raad/issues/7
- refactored Runner initialize/run/start_service methods
- custom options now uses options_parser class method in the service
- added examples/custom_options.rb
