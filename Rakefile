#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# require File.expand_path('../config/application', __FILE__)

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


task :default => [:test,:shell]
# EnglishScript::Application.load_tasks


desc "running all tests"
task :test do
    test_files = Dir['./src/test/unit/*_test.rb'] #FileList
    p test_files
    Rake::TestTask.new do |t|
      $use_tree=false
      t.libs << "test"
      t.test_files =  test_files
      # t.verbose = true
      t.verbose = false
    end
    # test_files.each{|f|$use_tree=false;system(f)}
end

desc "build binaries"
task :build do
  mkdir_p "build"
  # system("mrbc ./src/core/english-parser.rb")
  system("touch ./bin/angle")
  # ruby("buildall.rb", "apps")
end

task :compile => :build

desc "run an angle file (interpreted)"
task :run, [:file_name] => [:compile]  do
  system("./src/core/english-parser.rb #{args[:file_name]||''}")
end

desc "start angle REPL shell"
task :shell do
  system("./src/core/english-parser.rb")
end  

task :start => :run
task :interpret => :run
task :script => :run
task :emit => :compile

task :init do
  mkdir_p 'dist'
  mkdir_p 'build'
end

desc "clean up build artifacts"
task :clean do
  # ant.delete 'quiet' => true, 'dir' => 'build'
  rm_f 'build/*'
  rm_rf 'tmp'
end