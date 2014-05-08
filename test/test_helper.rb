ENV["RAILS_ENV"] = "test"
@@testing=true
$testing=true
require "test/unit"
# require_relative "../core/extensions"
require_relative "../core/english-parser"
# require File.expand_path('../../config/environment', __FILE__)
# require 'rails/test_help'
# class Test::Unit::TestCase
#   # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
#   #
#   # Note: You'll currently still have to declare fixtures explicitly in integration tests
#   # -- they do not yet inherit this setting
#   fixtures :all
#
#   # Add more helper methods to be used by all tests here...
# end
