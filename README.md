# LazyAsJson

A simple and concise way to use as_json with “only”, “except” and other options without using them literally.

Instead of using this -

`User.as_json(only: [:id, :first_name, profiles: [:company, :location]])`

You can perhaps use this -

`User.as_json(only_keys: ‘_,first_name,profiles(p),p.company,p.location’)`

As simple as this.

You can control what your API response should include through a flexible parameter string.

i.e. - “/api/v1/users/me?_keys=_,last_name,profiles(p),p.company,p.location”

This parameter string could dig through the nested objects and their nesting too.
Just to reduce the API response size significantly, you can use this parameter control over wherever it is used.
However it might seems quite trivial but frankly speaking it saves lot in response data hence faster loading time at client side.

Moreover as it uses Hash.new and constructs attribute on runtime, you can throttle calling from the expensive method by using this parameter string.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lazy_as_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_as_json

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lazy_as_json.
