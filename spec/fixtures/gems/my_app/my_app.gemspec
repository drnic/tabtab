# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{my_app}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dr Nic Williams"]
  s.date = %q{2008-11-16}
  s.default_executable = %q{test_app}
  s.description = %q{Simple CLI app + in-built autocompletions}
  s.email = ["drnicwilliams@gmail.com"]
  s.executables = ["test_app"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "Rakefile", "bin/test_app", "lib/ezy_auto_completions_definitions.rb", "lib/my_app.rb", "my_app.gemspec"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{my_app}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple CLI app + in-built autocompletions}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.1.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
