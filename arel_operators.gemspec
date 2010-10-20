# -*- encoding: utf-8 -*-

require 'rake'

Gem::Specification.new do |s|
  s.name = "arel_operators"
  s.version = "0.1.1"
  s.author = "Maurício Szabo"
  s.email = "mauricio.szabo@gmail.com"
  s.homepage = "http://github.com/mauricioszabo/arel_operators"
  s.platform = Gem::Platform::RUBY
  s.summary = "Operators (|, &, -) for ActiveRecord."
  s.files = FileList["{lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{spec}/**/*spec.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("activerecord", ">= 3.0.0")
end
