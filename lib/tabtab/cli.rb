require 'optparse'

module TabTab
  class CLI
    include TabTab::LocalConfig

    attr_reader :stdout
    attr_reader :app_type, :full_line
    attr_reader :global_config

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      @stdout = stdout
      # require "shellwords"
      # @full_line = ENV['COMP_LINE']
      # @full_line_argv = Shellwords.shellwords(@full_line)
      return "" unless @app_type = arguments.shift
      load_global_config
      case @app_type.gsub(/^-*/, '').to_sym
      when :external
        process_external *arguments
      when :gem
        process_gem arguments
      when :file
        process_file arguments
      else
        usage
      end
    end
    
    #
    # Support for external apps (optionally configured in ~/.tabtab.yml)
    # Generates a completion list from the -h help output of the target application
    #   --external
    #
    def process_external(app_name, current, previous)
      usage unless config
      options_flag = externals.find { |flag, app_list| app_list.include?(app_name) }
      options_flag = options_flag.nil? ? '-h' : options_flag.first
      stdout.puts external_options(app_name, options_flag).starts_with(current)
    end
    
    def externals
      config["external"] || config["externals"]
    end
    
    def external_options(app, options_flag)
      TabTab::Completions::External.new(app, options_flag, global_config)
    end
    
    #
    # Support for RubyGem-based completion definitions (found in any gem path)
    #   --gem gem_name
    #
    def process_gem arguments
      gem_name, app_name, current_token, previous_token = arguments
      stdout.puts TabTab::Completions::Gem.new(gem_name, app_name, current_token, previous_token, global_config).extract.join("\n")
    end
    
    #
    # Support for file-based completion definitions (found in target file)
    #   --file /path/to/definition.rb
    #
    def process_file arguments
      file_path, app_name, current_token, previous_token = arguments
      stdout.puts TabTab::Completions::File.new(file_path, app_name, current_token, previous_token, global_config).extract.join("\n")
    end
    
    def load_global_config
      @global_config ||= {}
      @global_config[:shortflags] = config["shortflags"] || "enable"
    end
    
    def usage
      stdout.puts <<-EOS.gsub(/^      /, '')
      Invalid #{@app_type} flag provided to #{$0}. 
      USAGE: 
        #{$0} --external
        #{$0} --gem GEM_NAME
        #{$0} --file FILE_PATH
      EOS
      exit
    end
  end
end