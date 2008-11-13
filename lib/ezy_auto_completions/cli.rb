require 'optparse'
require 'ezy_auto_completions/local_config'

module EzyAutoCompletions
  class CLI
    include EzyAutoCompletions::LocalConfig

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      usage unless config # TODO not fatal - try --auto-completion-script option?
      app, *args = arguments
      options_flag = externals.find { |flag, app_list| app_list.include?(app) }
      usage if options_flag.nil?
      options_flag = options_flag.first
      external_options(app, options_flag).starts_with(args.first)
    end
    
    def usage
      puts <<-EOS.gsub(/^      /, '')
      NOTE: Do not execute this application directly. It is to be called via
      your shell's completion mechanism, e.g. bash's complete command.
      EOS
      exit 1
    end
    
    def externals
      config["external"] || config["externals"]
    end
    
    def external_options(app, options_flag)
      options_str = `#{app} #{options_str}`
      EzyAutoCompletions::ExtractHelpOptions.new(options_str)
    end
  end
end