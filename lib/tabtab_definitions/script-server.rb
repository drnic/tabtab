TabTab::Definition.register('script/server', :import => true) do |c|
  c.flag :environment, :e do
    Dir['config/environments/*.rb'].map { |env| env.gsub(/^.*environments\//,'').gsub(/.rb$/,'') }
  end
  # script/server -p TABTAB -> generated first available port 3000, 3001, 3002
  c.flag :port, :p do
    port = 3000
    until `netstat -an | grep "^tcp" | grep #{port}`.strip.empty? || port > 3010
      port += 1
    end
    port > 3010 ? [] : [port.to_s]
  end
end

