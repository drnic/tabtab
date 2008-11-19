require 'optparse'

module TabTab
  class CLI
    include TabTab::LocalConfig

    attr_reader :stdout
    attr_reader :full_line
    attr_reader :arguments, :options, :global_config
    

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      @stdout = stdout
      # require "shellwords"
      # @full_line = ENV['COMP_LINE']
      # @full_line_argv = Shellwords.shellwords(@full_line)
      # cli_arguments, completion_arguments = arguments[0..-4], arguments[-3..-1]
      @arguments = parse_options(arguments)
      load_global_config
      if options[:external]
        process_external
      elsif options[:gem]
        process_gem
      elsif options[:file]
        process_file
      else
        usage
      end
    end
    
    def parse_options(arguments)
      @options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: $0 [options] app_name current_token previous_token"
    
        opts.on("--alias", "Map an alias to an actual command with its own tabtab definition") do |v|
          options[:alias] = v
        end
        opts.on("--external", "Automatically import flags from application's -h flags") do
          options[:external] = true
        end
        opts.on("--gem", "Load the tabtab definition from within target RubyGem") do |v|
          options[:gem] = v
        end
        opts.on("--file", "Load the tabtab definition from a specific file") do |v|
          options[:file] = v
        end
      end.parse!(arguments)
    end
    
    #
    # Support for external apps (optionally configured in ~/.tabtab.yml)
    # Generates a completion list from the -h help output of the target application
    #   --external
    #
    def process_external
      usage unless config
      app_name, current, previous = arguments
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
    def process_gem
      gem_name, app_name, current_token, previous_token = arguments
      stdout.puts TabTab::Completions::Gem.new(gem_name, app_name, current_token, previous_token, global_config).extract.join("\n")
    end
    
    #
    # Support for file-based completion definitions (found in target file)
    #   --file /path/to/definition.rb
    #
    def process_file
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