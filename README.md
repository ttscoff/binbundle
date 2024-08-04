# Binbundle

[![Gem](https://img.shields.io/gem/v/binbundle.svg)](https://rubygems.org/gems/na)
[![GitHub license](https://img.shields.io/github/license/ttscoff/binbundle.svg)](./LICENSE.txt)

Creates a "bundle" file of all installed gems with executables. The resulting file is an executable script that can be run standalone, or in combination with this script to add options like `sudo` or `--user-install` to the `gem install` commands. These options can be specified when creating the file as well. A file created with `sudo` or `--user-install` commands can still be overridden when running via this script and `--install`.

Created file is called `Binfile` in the current directory unless another path is specified with `--file`.

### Installation

Install with:

    $ gem install binbundle

If this causes errors, use:

    $ gem install --user-install binbundle

### Usage

Run `binbundle bundle` to create a Binfile in the current directory, or with `--file FILENAME` to specify a path/filename. That file can optionally be made executable (you'll be prompted). In the future when doing a clean install or using a new system, you can just run that file as a standalone to reinstall all of your gem binaries.

Example:

    binbundle bundle --file ~/dotfiles/Binfile

Using this script with the `install` subcommand will read the Binfile and execute it line by line, adding options like version numbers, sudo, or the `--user-install` flag, overriding any of these specified when bundling.

Example:

    binbundle install --no-versions --user-install --file ~/dotfiles/Binfile

The available subcommands are:

- `bundle`: create a new Binfile (or specified --file)
- `install`: install gems from Binfile
- `gem for EXE`: find out which gem is responsible for an executable EXE (e.g. `binbundle gem for searchlink`)
- `bin for GEM`: find out what executables gem GEM installs (e.g. `binbundle bin for yard`)

#### Options

```
Usage: binbundle [options] [bundle|install]
        --[no-]versions              Include version info in output (default true)
        --dry-run                    Output to STDOUT instead of file
    -s, --sudo                       Install gems with sudo
    -u, --user-install               Use --user-install to install gems
    -f, --file FILE                  Output to alternative filename (default Binfile)
    -l, --local                      Use installed gems instead of Binfile for gem_for and bins_for
    -v, --version                    Display version
    -h, --help                       Display this screen
```

#### Info commands

You can retrieve some basic info about gems and their binaries using `binbundle gem for BIN` or `binbundle bins for GEM`. This will read `Binfile` or any file specified by `--file` and return the requested info, either the gem associated with the given binary (BIN), or the binaries associated with the given gem name (GEM).

Use either info command with `--local` to parse installed gems rather than a Binfile.

### Recommendations

I recommend using Binbundle along with a tool like [Dotbot](https://github.com/anishathalye/dotbot). Commit your bundle to a repo that you can easily clone to a new machine and then make `gem install binbundle` and `binbundle install ~/dotfiles/Binfile` part of your restore process.


### Support

PayPal link: [paypal.me/ttscoff](https://paypal.me/ttscoff)

### Changelog

See [CHANGELOG.md](https://github.com/ttscoff/binbundle/blob/main/CHANGELOG.md)

### Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/ttscoff/binbundle>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ttscoff/binbundle/blob/main/CODE_OF_CONDUCT.md).

### License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Code of Conduct

Everyone interacting in the Binbundle project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ttscoff/binbundle/blob/main/CODE_OF_CONDUCT.md).
