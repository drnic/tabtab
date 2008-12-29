TabTab::Definition.register('rake', :import => true) do |c|
  def rake_silent_tasks
    # TODO cache per directory
    `rake --silent --tasks`
  end
  # c.cache :rake_silent_tasks, :per => :folder
  
  c.default do |cmd|
    next [] if cmd.current_token.nil? # TODO why are these blocks invoked twice? (1st on setup, 2nd for parsing)
    tasks = (rake_silent_tasks.split("\n")[1..-1] || []).map { |line| line.split[1] }
    if cmd.current_token =~ /^([-\w:]+:)/
      upto_last_colon = Regexp.escape($1)
      tasks = tasks.select { |task| /^#{Regexp.escape cmd.current_token}/ =~ task }
      tasks.map! { |task| task.gsub(/#{Regexp.escape upto_last_colon}/, '')  }
    end
    tasks
  end
  c.flags :silence, :s
  c.flags :trace, :t
end
