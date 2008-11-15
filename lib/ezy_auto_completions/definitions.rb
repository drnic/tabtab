module EzyAutoCompletions::Definition
  class InvalidDefinitionBlockArguments < Exception; end
end

Dir[File.dirname(__FILE__) + "/definitions/*.rb"].sort.each do |definition|
  require definition.gsub(/.rb$/,'')
end