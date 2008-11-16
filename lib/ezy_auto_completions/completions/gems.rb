class EzyAutoCompletions::Completions::Gem
  attr_reader :gem_name, :app_name, :current_token, :previous_token
  
  def initialize(gem_name, app_name, current_token, previous_token)
    @gem_name = gem_name
    @app_name = app_name
    @current  = current_token
    @previous = previous_token
  end

  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def extract
    require "rubygems"
    require "ezy_auto_completions/definitions"
    orig_load_path = $LOAD_PATH.clone
    gem gem_name
    gem_lib_path = ($LOAD_PATH - orig_load_path).grep(/lib$/).first.gsub(/\/lib$/, '')
    if definitions_file = Dir[File.join(gem_lib_path, '**', "ezy_auto_completions_definitions.rb")].first
      load definitions_file
      EzyAutoCompletions::Definition[app_name].extract_completions(previous_token, current_token)
    else
      []
    end
  end
end
