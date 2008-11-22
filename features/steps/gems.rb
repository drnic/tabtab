Given %r{^a user's RubyGems gem cache} do
  Given "a safe folder"
  Given "env variable $GEM_HOME set to '#{gem_install_dir}'"
end

def gem_install_dir
  install_dir = File.expand_path(File.join(@home_path), ".gem/ruby/1.8")
end

Given /^a RubyGem '(.*)' with executable '(.*)' with autocompletions$/ do |gem_name, executable|
  @stdout = File.expand_path(File.join(@tmp_root, "geminstall.txt"))
  @stderr = File.expand_path(File.join(@tmp_root, "geminstall.err"))
  FileUtils.chdir(File.join(File.dirname(__FILE__) + "/../../spec/fixtures/gems/#{gem_name}")) do
    system "rake gemspec > #{@stdout} 2> #{@stderr}"
    system "gem build #{gem_name}.gemspec > #{@stdout} 2> #{@stderr}"
    system "gem install --install-dir #{gem_install_dir} #{gem_name}*.gem > #{@stdout} 2> #{@stderr}"
  end
end
