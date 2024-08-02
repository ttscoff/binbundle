<!--README--><!--GITHUB--># Binbundle

[![Gem](https://img.shields.io/gem/v/binbundle.svg)](https://rubygems.org/gems/na)
[![GitHub license](https://img.shields.io/github/license/ttscoff/binbundle.svg)](./LICENSE.txt)<!--END GITHUB-->

Creates a "bundle" file of all installed gems with executables. The resulting file is an executable script that can be run standalone, or in combination with this script to add options like `sudo` or `--user-install` to the `gem install` commands. These options can be specified when creating the file as well. A file created with `sudo` or `--user-install` commands can still be overridden when running via this script and `--install`.

Created file is called `Binfile` in the current directory unless another path is specified with `--file`.

## Installation

Install with:

    $ gem install binbundle

If this causes errors, use:

    $ gem install --user-install binbundle

## Usage

Run `binbundle` to create a Binfile in the current directory. That file can optionally be made executable (you'll be prompted). In the future when doing a clean install or using a new system, you can just run that file as a standalone to reinstall all of your gem binaries.

Using this script with the `--install` flag will read the Binfile and execute it line by line, adding options like version numbers, sudo, or the `--user-install` flag.

You can also run with subcommands `bundle` or `install`, e.g. `bundle_gem_bins install`.

```
Usage: binbundle [options] [bundle|install]
        --[no-]versions              Include version info in output (default true)
        --dry-run                    Output to STDOUT instead of file
    -s, --sudo                       Install gems with sudo
    -u, --user-install               Use --user-install to install gems
    -f, --file FILE                  Output to alternative filename (default Binfile)
    -v, --version                    Display version
        --install                    Run bundle script
    -h, --help                       Display this screen
```

<!--GITHUB-->

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/ttscoff/binbundle>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ttscoff/binbundle/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Binbundle project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ttscoff/binbundle/blob/main/CODE_OF_CONDUCT.md).

## Support

PayPal link: [paypal.me/ttscoff](https://paypal.me/ttscoff)

## Changelog

See [CHANGELOG.md](https://github.com/ttscoff/binbundle/blob/main/CHANGELOG.md)
<!--END GITHUB--><!--END README-->
