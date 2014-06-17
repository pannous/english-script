# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "english-script"
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pannous"]
  s.date = "2014-06-16"
  s.description = "English as a programming language!"
  s.email = "info@pannous.com"
  # s.extensions = ["ext/json/ext/generator/extconf.rb", "ext/json/ext/parser/extconf.rb"]
  s.extra_rdoc_files = ["README.md"]
  s.files = [".gitignore", "core/*","word-lists/*","test/*","english-script.sh"]
  s.homepage = "https://github.com/pannous/english-script"
  s.rdoc_options = ["--title", "English as a programming language!", "--main", "README.md"]
  s.require_paths = ["core"]
  s.rubyforge_project = "json"
  s.rubygems_version = "0.8.1"
  s.summary = "English as a programming language!"
  s.test_files = ["./tests/*.rb"]

end
