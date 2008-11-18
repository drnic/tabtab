TabTab::Definition.register('rails', :import => true) do |c|
  c.flags :database, :d do
    "mysql/oracle/postgresql/sqlite2/sqlite3/frontbase".split('/')
  end
  c.flags :ruby, :r do
    ENV['PATH'].split(":").inject([]) do |mem, path|
      %w[ruby macruby jruby].each do |ruby|
        ruby = File.join(path, "ruby")
        mem << ruby if File.exists?(ruby)
      end
      mem
    end
  end
end

