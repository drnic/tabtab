class TabTab::Completions::File
  attr_reader :file_path, :app_name, :current_token, :previous_token
  
  def initialize(file_path, app_name, current_token, previous_token)
    @file_path      = file_path
    @app_name       = app_name
    @current_token  = current_token
    @previous_token = previous_token
  end

  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def extract
    if File.exists?(file_path)
      definitions_file = File.read(file_path)
      eval definitions_file
      TabTab::Definition[app_name].extract_completions(previous_token, current_token)
    else
      []
    end
  end
end
