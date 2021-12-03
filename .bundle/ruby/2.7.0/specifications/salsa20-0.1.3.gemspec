# -*- encoding: utf-8 -*-
# stub: salsa20 0.1.3 ruby lib
# stub: ext/salsa20_ext/extconf.rb

Gem::Specification.new do |s|
  s.name = "salsa20".freeze
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dov Murik".freeze]
  s.date = "2018-09-23"
  s.description = "    Salsa20 is a stream cipher algorithm designed by Daniel Bernstein. salsa20-ruby provides\n    a simple Ruby wrapper.\n".freeze
  s.email = "dov.murik@gmail.com".freeze
  s.extensions = ["ext/salsa20_ext/extconf.rb".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze, "LICENSE".freeze, "CHANGELOG".freeze, "lib/salsa20.rb".freeze]
  s.files = ["CHANGELOG".freeze, "LICENSE".freeze, "README.rdoc".freeze, "ext/salsa20_ext/extconf.rb".freeze, "lib/salsa20.rb".freeze]
  s.homepage = "https://github.com/dubek/salsa20-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "salsa20".freeze, "--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "3.2.24".freeze
  s.summary = "Salsa20 stream cipher algorithm.".freeze

  s.installed_by_version = "3.2.24" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.0"])
  else
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 6.0"])
  end
end
