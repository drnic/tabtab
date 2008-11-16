module EzyAutoCompletions::Definition
  class InvalidDefinitionBlockArguments < Exception; end

  class << self
    attr_reader :registrations

    def register(app_name, &block)
      @registrations ||= {}
      @registrations[app_name] = Root.named(app_name, &block)
    end
  end
end

Dir[File.dirname(__FILE__) + "/definitions/*.rb"].sort.each do |definition|
  require definition.gsub(/.rb$/,'')
end