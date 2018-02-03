# HIVE Service (Ruby Version)

This is a library that we include in any Ruby (Rails, Sinatra, etc.) app where we want to have access to HIVE, either by posting atoms in, or searching for atoms.

This library also defines a `HiveAtom` object.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hive_service_ruby', git: 'git@bitbucket.org:explo/hive-service-ruby.git'
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

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
