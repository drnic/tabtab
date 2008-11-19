TabTab::Definition.register('script/generate', :import => true) do |c|
  c.default do
    generator_help = `script/generate`
    generator_help.scan(/^\ +\w+:\s(.*)$/).map do |list|
      list.first.strip.split(/,[\s\n]*/)
    end.flatten
  end
end