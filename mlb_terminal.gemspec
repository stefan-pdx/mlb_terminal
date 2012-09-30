# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mlb_terminal/version"

Gem::Specification.new do |s|
  s.name        = "mlb_terminal"
  s.version     = MLBTerminal::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stefan Novak"]
  s.email       = ["stefan.louis.novak@gmail.com"]
  s.homepage    = "https://github.com/slnovak/mlb_terminal"
  s.description = %q{A small terminal app to translate MLB baseball feeds into the terminal for easy manipulation.} 
  s.summary     = %q{Command line interface to keeping track of MLB ballgames}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "commander", "~> 4.1.2"
  s.add_dependency "nokogiri", "~> 1.5.5"
  s.add_dependency "activesupport", "~> 3.2.8"
end
