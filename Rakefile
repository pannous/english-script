#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake/clean'
require 'rake/testtask'
# require 'rspec/core/rake_task'

# Bundler::GemHelper.install_tasks
# desc "Run all examples"
# RSpec::Core::RakeTask.new(:spec)
# task :default => :spec
# task :test => :spec

# require "rubygems"
# gem 'hoe', '>= 2.1.0'
# require 'hoe'
# 
# Hoe.plugins.delete :rubyforge
# Hoe.plugin :minitest
# Hoe.plugin :gemspec # `gem install hoe-gemspec`
# Hoe.plugin :git     # `gem install hoe-git`


task :default => [:test]
# EnglishScript::Application.load_tasks
# task :default => :test

task :test do
    Rake::TestTask.new do |t|
      t.libs << "test"
      t.test_files = FileList['./src/test/unit/*_test.rb']
      t.verbose = true
    end
    test_files = Dir['./src/test/unit/*_test.rb'] #FileList
    p test_files
    test_files.each{|f|system(f)}
    # chdir("src/test") { system "./tests.sh" }
  # do_test 'src/test/ruby/hello.rb'
  # puts "TODO: test!"
end

task :build do
  mkdir_p "build"
  # ruby("buildall.rb", "apps")
end
