TabTab::Definition.register('cucumber', :import => '--help') do |c|
  c.flags(:color)
  c.flags(:"no-color")
  c.flags(:profile, :p) do
    next [] unless File.exists?('cucumber.yml')
    require 'yaml'
    YAML.load(File.read('cucumber.yml')).keys
  end
  c.flags(:format, :f) do
    help = `cucumber -h`
    languages = help.match(/Available formats:(.*)$/)[1]
    languages.split(/,\s*/)
  end
  c.flags(:language, :a) do
    help = `cucumber -h`
    languages = help.match(/Available languages:(.*)$/)[1]
    languages.split(/,\s*/)
  end
end