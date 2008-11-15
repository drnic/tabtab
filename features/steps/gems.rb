Given %r{^a user's RubyGems gem cache} do
  Given "a safe folder"
end

Given /^a RubyGem '(.*)' with executable '(.*)' with autocompletions$/ do |gem, executable|
  gem_path = File.join(Gem.user_dir, "gems", gem)
  %w[bin lib].each { |path| FileUtils.mkdir_p(File.join(gem_path, path)) }
  FileUtils.cp(File.dirname(__FILE__) + "/../fixtures/bin/test_app", File.join(gem_path, 'bin', executable))
end
