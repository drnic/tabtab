TabTab::Definition.register('newgem', :import => true) do |c|
  c.flags :"test-with", :T, "Select your preferred testing framework." do
    %w[ test_unit rspec ]
  end
  c.flags :install, :i, "Installs a generator called install_<generator>." do
    # require "rubigen"
    # RubiGen::Base.use_component_sources! [:rubygems, :newgem, :newgem_theme]
    # RubiGen::Scripts::Generate.new.run([])
    # TODO - function to return list of available generators
    # TODO - make script/generate work for rubigen + rails
    generators = <<-EOS.strip.split(/,[\s\n]*/)
    application_generator, component_generator, executable, extconf,
    install_jruby, install_rspec, install_test_unit, install_website,
    long_box_theme, plain_theme, rails, rspec_controller, rspec_model, test_unit
    EOS
    generators.grep(/^install_/).map { |name| name.gsub(/^install_/, '') }
  end
  c.flags :ruby, :r do
    ENV['PATH'].split(":").inject([]) do |mem, path|
      %w[ruby macruby jruby].each do |ruby|
        ruby = File.join(path, "ruby")
        mem << ruby if File.exists?(ruby)
      end
      mem
    end
  end
end