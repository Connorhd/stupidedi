require File.dirname(__FILE__) + "/lib/stupidedi/version"

Gem::Specification.new do |s|
  s.name        = "stupidedi"
  s.summary     = "Parse, generate, validate ASC X12 EDI"
  s.description = "Ruby API for parsing and generating ASC X12 EDI transactions"
  s.homepage    = "https://github.com/kputnam/stupidedi"

  s.version = Stupidedi::VERSION
  s.date    = "2016-07-29"
  s.author  = "Kyle Putnam"
  s.email   = "putnam.kyle@gmail.com"

  s.files             = %w(README.md Rakefile)
                          + Dir.glob("bin/*")
                          + Dir.glob("lib/**/*")
                          + Dir.glob("doc/**/*.md")
                          + Dir.glob("spec/**/*")
  s.test_files        = Dir.glob("spec/examples/**/*.example")
  s.has_rdoc          = false
  s.bindir            = "bin"
  s.executables       = ["edi-pp", "edi-ed"]
  s.require_path      = "lib"

  s.add_dependency "term-ansicolor", "~> 1.3"
  s.add_dependency "cantor",         "~> 1.2.1"
end
