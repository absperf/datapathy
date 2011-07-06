# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "datapathy/version"

Gem::Specification.new do |s|
  s.name        = "datapathy"
  s.version     = Datapathy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Absolute Performance, Inc"]
  s.email       = ["info@absolute-performance.com"]
  s.homepage    = ""
  s.summary     = %q{The stupid-simple ORM.}
  s.description = %q{The stupid-simple ORM.}

  s.rubyforge_project = "datapathy"

  rails_version = "~> 3.0.7"

  s.add_dependency "activesupport", rails_version
  s.add_dependency "activemodel",   rails_version
  s.add_dependency "railties",      rails_version
  s.add_dependency "resourceful", "~> 1.0"

  s.add_development_dependency "rspec", ">= 2.0"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "machinist", "~> 1.0.6"
  s.add_development_dependency "faker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
