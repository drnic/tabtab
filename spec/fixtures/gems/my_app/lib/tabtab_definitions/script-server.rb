TabTab::Definition.register('script/server') do |c|
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

