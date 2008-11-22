class TabTab::Completions::Gem
  attr_reader :gem_name, :app_name, :current_token, :previous_token, :global_config, :definitions_file
  
  def initialize(gem_name, app_name, current_token, previous_token, global_config = {})
    parse_gem_name_and_optional_explicit_file(gem_name)
    @app_name       = app_name
    @current_token  = current_token
    @previous_token = previous_token
    @global_config  = global_config
  end

  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def extract
    require "tabtab/definitions"
    load definitions_file
    if TabTab::Definition[app_name]
      TabTab::Definition[app_name].extract_completions(previous_token, current_token, global_config)
    else
      []
    end
  end
  
  def load_gem_and_return_definitions_file
    Dir[File.join(gem_root_path, '**', "tabtab_definitions.rb")].first
  end
  
  def parse_gem_name_and_optional_explicit_file(gem_name)
    if gem_name =~ %r{^([\w\-_]*)/(.*)}
      @gem_name, file_path = $1, $2
      @definitions_file = File.join(gem_root_path, file_path)
    else
      @gem_name = gem_name
      @definitions_file = load_gem_and_return_definitions_file
    end
  end

  def gem_root_path
    require "rubygems"
    gem gem_name
    $LOAD_PATH.grep(/#{gem_name}.*\/lib$/).first.gsub(/\/lib$/, '')
  end
end
