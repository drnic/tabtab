module TabTab::Definition
  class InvalidDefinitionBlockArguments < Exception; end

  class << self
    attr_reader :registrations
    
    def initialize
      clear
    end
    
    def register(app_name, &block)
      registrations[app_name] = Root.named(app_name, &block)
    end
    
    def [](app_name)
      registrations[app_name]
    end
    
    def clear
      @registrations = {}
    end
    
    def app_names
      registrations.keys
    end
  end
end

Dir[File.dirname(__FILE__) + "/definitions/*.rb"].sort.each do |definition|
  require definition.gsub(/.rb$/,'')
end