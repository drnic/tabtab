require 'optparse'

module TabTab
  class CLI
    include TabTab::LocalConfig

    attr_reader :stdout
    attr_reader :full_line
    attr_reader :options, :global_config
    attr_reader :current_token, :previous_token
    

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      @stdout = stdout
      # require "shellwords"
      # line  = ENV['COMP_LINE']
      # words = Shellwords.shellwords(line)
      # current = line =~ /\s$/ ? "" : words[-1]
      # STDERR.puts words.inspect
      # STDERR.puts words[-1]
      # STDERR.puts current
      @app_name, @current_token, @previous_token = arguments[-3..-1]
      parse_options(arguments[0..-4])
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
        opts.banner = "Usage: #{$0} [options] app_name current_token previous_token"
    
        opts.on("--alias ALIAS", "Map an alias to an actual command with its own tabtab definition") do |v|
          options[:alias] = v
        end
        opts.on("--external", "Automatically import flags from application's -h flags") do |v|
          options[:external] = v
        end
        opts.on("--gem GEM_NAME", "Load the tabtab definition from within target RubyGem") do |v|
          options[:gem] = v
        end
        opts.on("--file FILE_NAME", "Load the tabtab definition from a specific file") do |v|
          options[:file] = v
        end
      end.parse!(arguments)
    end
    
    def app_name
      options[:alias] || @app_name
    end
    
    #
    # Support for external apps (optionally configured in ~/.tabtab.yml)
    # Generates a completion list from the -h help output of the target application
    #   --external
    #
    def process_external
      usage unless config
      # 'externals' => ['app1', 'app2', { '-?' => ['app3'] }]
      # Only look for the internal hashes, and return -? if app_name == 'app3', else nil
      options_flag = externals.inject(nil) do |o_flag, app_or_hash|
        next if app_or_hash.is_a?(String) || app_or_hash.is_a?(Symbol)
        app_or_hash.inject(nil) do |flag, flag_app_list|
          flag, app_list = flag_app_list
          flag if app_list.include?(app_name)
        end
      end
      options_flag = options_flag.nil? ? '-h' : options_flag
      stdout.puts TabTab::Completions::External.new(app_name, options_flag, global_config).starts_with(current_token)
    end
    
    def externals
      config["external"] || config["externals"]
    end
    
    #
    # Support for RubyGem-based completion definitions (found in any gem path)
    #   --gem gem_name
    #
    def process_gem
      stdout.puts TabTab::Completions::Gem.new(options[:gem], app_name, current_token, previous_token, global_config).extract.join("\n")
    end
    
    #
    # Support for file-based completion definitions (found in target file)
    #   --file /path/to/definition.rb
    #
    def process_file
      stdout.puts TabTab::Completions::File.new(options[:file], app_name, current_token, previous_token, global_config).extract.join("\n")
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