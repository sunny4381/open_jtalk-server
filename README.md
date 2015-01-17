Open JTalk Server
===

This is Japanese Voice Synthesis Server using [Open JTalk](http://open-jtalk.sourceforge.net).

## Installation

install it yourself as:

    $ git clone git://github.com/sunny4381/open_jtalk-server.git
    $ cd open_jtalk-server
    $ bundler install
    $ bundler exec rails server

Brows "http://localhost:3000/"

### Supported Platform

Platforma  | Support
-----------|---------
Windows    | NO
Linux      | YES
Mac        | YES
Other Unix | Meybe YES

## Contributing

1. Fork it ( https://github.com/sunny4381/open_jtalk-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

open_jtalk-server contains several sub modules, and each module has released under its own license.

* open_jtalk-server is released under [BSD 2 Clause](http://opensource.org/licenses/BSD-2-Clause).
* open_jtalk-ruby is released under [BSD 2 Clause](http://opensource.org/licenses/BSD-2-Clause).
* open_jtalk is released under [Modified BSD license](http://www.opensource.org/).
* hts_engine_api is released under [Modified BSD license](http://www.opensource.org/).
* MeCab is released under [New BSD License](http://opensource.org/licenses/BSD-3-Clause).
