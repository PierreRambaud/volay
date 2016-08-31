#Volay, the Volume System Tray

[![Build Status](https://travis-ci.org/PierreRambaud/volay.svg)](https://travis-ci.org/PierreRambaud/volay)

##Requirements

 * Ruby 2.0 or newer

##Installation

From Rubygems:

```
$ gem install volay
```

From Github:

```
$ git clone https://github.com/PierreRambaud/volay.git
$ cd volay
$ bundle install
$ bundle exec rake install
```

## Usage

```bash
$ volay -h
Volay, the Volume System Tray.
    -d, --down PERCENT               Down volume
    -l, --log_level LEVEL            Set the log level (debug, info, warn, error, fatal)
    -m, --toggle-mute                Toggle mute
    -u, --up PERCENT                 Up volume
    -h, --help                       Show this message
```

If no arguments are passed, the Gtk app is launched.

## Running tests

To run unit tests:
`$ bundle exec rake spec`

To check code style:
`$ bundle exec rake rubocop`

To run all tests:
`$ bundle exec rake`

## License
See [LICENSE](LICENSE) file
