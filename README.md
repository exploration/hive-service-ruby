# HIVE Service (Ruby Version)

This is a library that we include in any Ruby (Rails, Sinatra, etc.) app where we want to have access to HIVE, either by posting atoms in, or searching for atoms.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hive_service', git: 'git@github.com:exploration/hive-service-ruby.git'
```

And then execute:

    $ bundle

## Usage

In your app, you must of course:

    require 'hive_service'

Here's an example of how your might use the HIVE Service to search for some unseen atoms from the Portal:

    hs = HiveService::HiveService.new(
      application_name: 'hive_service_ruby_test',
      hive_base_uri: 'https://my_hive_server.com',
      hive_token: ENV['HIVE_API_TOKEN']
    )

    atoms = hs.get_unseen_atoms(
      application: 'portal_production',
      context: 'course',
      receipts: 'my_kewl_app'
    )

    # `atoms` will be a list of HiveAtom objects
    puts atoms.count

## Development

After checking out the repo, run `bin/setup` to install dependencies.

On first installation, and after you've changed any code, run `rake test` to run the tests. Once your tests are passing, you'll also want to run `rake rubocop` or simply `rubocop` to run additional code tests. Alternatively, you can run `rake check_all` or simply `rake` to run the test suite, Rubocop, and Yard documentation in one pass.

You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Documentation

This source code is compatible with [YARD](https://yardoc.org/) for documentation. To generate the docs, simply type `yardoc`.

To view the generated documentation, you can open the `index.html` file in the `docs` directory.

## Changelog
- 0.1.6 - Added `service.get_atom(id)`
