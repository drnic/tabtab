module TabTab::Completions
end

Dir[File.dirname(__FILE__) + "/completions/*.rb"].each do |path|
  require path.gsub(/.rb$/, '')
end