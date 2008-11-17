TabTab::Definition.register('test_app') do |c|
  c.flags :help, :h, "help"
  c.flags :extra, :x
  c.command :root do
    puts "root"
    %w[aaa bbb]
  end
  c.command :outer do |o|
    o.default do
      puts "outer"
      %w[aaa bbb]
    end
    o.command :middle do |m|
      m.command :inner do
        puts "inner"
        %w[aaa bbb]
      end
    end
  end
end

