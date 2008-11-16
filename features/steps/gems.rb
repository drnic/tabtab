Given %r{^a user's RubyGems gem cache} do
  Given "a safe folder"
end

Given /^a RubyGem '(.*)' with executable '(.*)' with autocompletions$/ do |gem, executable|
  gem_path = File.join(Gem.user_dir, "gems", gem)
  FileUtils.cp_r(File.dirname(__FILE__) + "/../fixtures/gems/#{gem}", gem_path)
  Dir[File.join(gem_path, "/#{gem}/**/*.rb_")].each do |file|
    FileUtils.mv(file, file.gsub(/rb_$/, 'rb'))
  end
end
