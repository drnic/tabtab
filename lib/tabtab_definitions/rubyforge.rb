TabTab::Definition.register('rubyforge', :import => true) do |c|
  def groups
    require "yaml"
    config = YAML.load(File.read(File.expand_path("~/.rubyforge/auto-config.yml")))
    config["group_ids"].keys
  end

  def projects
    require "yaml"
    config = YAML.load(File.read(File.expand_path("~/.rubyforge/auto-config.yml")))
    config["project_ids"].keys
  end

  c.command :setup
  c.command :help
  c.command(:config) { projects }
  c.command :names
  c.command :login do |login|
    login.flag :username
    login.flag :password
  end
  # TODO - need nesting of default blocks: rubyforge create_package group_id package_name
  # This will probably require access to $COMP_LINE
  c.command(:create_package) { groups }
  c.command(:add_release) { groups }
  c.command(:add_file) { groups }
  c.command(:delete_package) { groups }
end

