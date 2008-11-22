Dir[File.dirname(__FILE__) + "/tabtab_definitions/**/*.rb"].each do |definition|
  load definition
end