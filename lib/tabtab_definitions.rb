# initially we're only preloading these to demonstrate the purpose
# some of the remaining definitions are not finished or buggy in some way
%w[cucumber github newgem rails].each do |app_name|
  load File.dirname(__FILE__) + "/tabtab_definitions/#{app_name}.rb"
end