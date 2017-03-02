# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "shared_should/version"

Gem::Specification.new do |s|
  s.name        = "shared_should"
  s.version     = SharedShould::VERSION
  s.authors     = ["Michael Pearce"]
  s.email       = ["michaelgpearce@yahoo.com"]
  s.homepage    = "http://github.com/michaelgpearce/shared_should"
  s.summary     = "Share and reuse shoulds, contexts, and setup in Shoulda."

  s.rubyforge_project = "shared_should"

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'shoulda'
end
