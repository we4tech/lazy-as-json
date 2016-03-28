$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lazy_as_json'
require_relative 'support/factories'

RSpec.configure do |c|
  c.include LazyAsJsonFactories
end
