module TabTab::FrameworkTesting

  module StringExtensions
    def autocompletable_from?(autocompletion_definition)
      autocompletion_definition.autocompletable?(self)
    end
  end
  
end

String.send(:include, TabTab::FrameworkTesting::StringExtensions)