TabTab::Definition.register('rails') do |c|
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

