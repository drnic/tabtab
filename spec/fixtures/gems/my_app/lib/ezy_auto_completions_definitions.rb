EzyAutoCompletions::Definition.register('test_app') do |c|
  c.flags :help, :h, "help"
  c.flags :extra, :x
  c.command :unlock do |unlock|
    unlock.default do
      `git branch | sed -e "s/..//"`.split(/\n/) rescue []
    end
    unlock.flag :port, :p do
      port = 3000
      until `netstat -an | grep "^tcp" | grep #{port}`.strip.empty? || port > 3010
        port += 1
      end
      port > 3010 ? [] : [port.to_s]
    end
  end
  c.command :drink do
    %w[coke rum cola]
  end
  c.command :banana
end

EzyAutoCompletions::Definition.register('script/server') do |c|
  c.flag :binding, :b
  c.flag :daemon, :d
  c.flag :debugger, :x
  c.flag :help, :h
  # script/server -p TABTAB -> generated 3000, 30001
  c.flag :port, :p do
    port = 3000
    until `netstat -an | grep "^tcp" | grep #{port}`.strip.empty? || port > 3010
      port += 1
    end
    port > 3010 ? [] : [port]
  end
  c.flag :environment, :e do
    Dir['config/environments/*.rb'].map { |env| env.gsub(/^.*environments\//,'').gsub(/.rb$/,'') }
  end
end

EzyAutoCompletions::Definition.register('rails') do |c|
  c.flags :freeze, :f
  c.flags :version, :v
  c.flags :help, :h
  c.flags :pretend, :p
  c.flags :force
  c.flags :skip, :s
  c.flags :quiet, :q
  c.flags :backtrace, :t
  c.flags :svn, :c
  c.flags :git, :g
  c.flags :database, :d do
    "mysql/oracle/postgresql/sqlite2/sqlite3/frontbase".split('/')
  end
  c.flags :ruby, :r do
    ENV['PATH'].split(":").inject([]) do |mem, path|
      ruby = File.join(path, "ruby")
      mem << ruby if File.exists?(ruby)
      mem
    end
  end
end

EzyAutoCompletions::Definition.register('gem') do |c|
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
    Dir['**/*.gem']
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
    ['commands'] + EzyAutoCompletions::Definition['gem'].contents.select do |definition|
      definition.definition_type == :command
    end.map { |definition| definition.name }
  end
end