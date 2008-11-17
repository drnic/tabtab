module TabTab::Test::Assertions
  # assert_completable_to "github network --sort branch list --reverse"
  def assert_completable_to(full_command, root_definition)
    full_command.autocompletable_from?(root_definition)
  end
end
