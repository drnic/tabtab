class TabTab::Completions::Gem
  attr_reader :gem_name, :app_name, :current_token, :previous_token
  
  def initialize(gem_name, app_name, current_token, previous_token)
    @gem_name       = gem_name
    @app_name       = app_name
    @current_token  = current_token
    @previous_token = previous_token
  end

  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def extract
    require "rubygems"
    require "tabtab/definitions"
    if definitions_file = load_gem_and_return_definitions_file
      eval File.read(definitions_file)
      TabTab::Definition[app_name].extract_completions(previous_token, current_token)
    else
      []
    end
  end
  
  def load_gem_and_return_definitions_file
    orig_load_path = $LOAD_PATH.clone
    gem gem_name
    gem_lib_path = ($LOAD_PATH - orig_load_path).grep(/lib$/).first.gsub(/\/lib$/, '')
    Dir[File.join(gem_lib_path, '**', "tabtab_definitions.rb")].first
  end
end
