# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_as_json/version'

Gem::Specification.new do |spec|
  spec.name          = 'lazy_as_json'
  spec.version       = LazyAsJson::VERSION
  spec.authors       = ['nhm tanveer hossain khan']
  spec.email         = ['hasan83bd@gmail.com']

  spec.summary       = %q{Take control on what to return from the API response, define the attributes map in a short syntax over parameter}
  spec.description   = %q{Lazy As Json

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
}
  spec.homepage      = 'http://hasan.wordpress.com'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
