TabTab::Definition.register('gem') do |c|
  c.flags :version, :v
  c.flags :h
  
  c.command :build do
    Dir['**/*.gemspec']
  end
  c.command :check do |check|
    check.flags :a, :alien
    check.flags :t, :test
  end
  c.command :contents do
    `gem list --local --no-versions --no-details`.split(/\n/)[3..-1]
  end
  c.command :dependency do
    `gem list --local --no-versions --no-details`.split(/\n/)[3..-1]
  end
  c.command :install do |install|
    # TODO this is very slow and may require caching somehow?!
    install.default do
      `gem list --remote --no-versions --no-details`.split(/\n/)[3..-1]
    end
  end
  c.command :outdated do |outdated|
    outdated.flags :local, :l
    outdated.flags :remote, :r
    outdated.flags :source
    outdated.flags :platform do
      Gem.platforms.map { |platform| platform.to_s }
    end
  end
  c.command :specification do |spec|
    spec.default do
      `gem list --local --no-versions --no-details`.split(/\n/)[3..-1]
    end
    spec.flags :local, :l
    spec.flags :remote, :r
    spec.flags :source
    spec.flags :platform do
      Gem.platforms.map { |platform| platform.to_s }
    end
  end
  c.command :uninstall do |uninstall|
    uninstall.default do
      `gem list --local --no-versions --no-details`.split(/\n/)[3..-1]
    end
  end
  c.command :help do
    ['commands'] + TabTab::Definition['gem'].contents.select do |definition|
      definition.definition_type == :command
    end.map { |definition| definition.name }
  end
end

