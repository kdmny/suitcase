# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "suitcase/version"

Gem::Specification.new do |s|
  s.name        = "suitcase"
  s.version     = Suitcase::VERSION
  s.authors     = ["Walter Nelson"]
  s.email       = ["walter.john.nelson@gmail.com"]
  s.homepage    = "http://github.com/thoughtfusion/suitcase"
  s.summary     = %q{Locates available hotels and rental cars through Expedia and Hotwire}
  s.description = %q{Ruby library that utilizes the EAN (Expedia.com) API for locating available hotels and the Hotwire API for rental cars.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "minitest"
  s.add_development_dependency "mocha"
  s.add_development_dependency "turn"

  s.add_development_dependency "chronic"

  s.add_development_dependency "rake"
  s.add_development_dependency "pry"

  s.add_runtime_dependency "json"
  s.add_runtime_dependency "patron"
end