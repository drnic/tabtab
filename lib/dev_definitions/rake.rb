TabTab::Definition.register('rake', :import => true) do |c|
  def rake_silent_tasks
    # if File.exists?(dotcache = File.join(File.expand_path('~'), ".raketabs-#{Dir.pwd.hash}"))
    #   File.read(dotcache)
    # else
      tasks = `rake --silent --tasks`
      # File.open(dotcache, 'w') { |f| f.puts tasks }
      tasks
    # end
  end
  
  c.default do |current|
    tasks = (rake_silent_tasks.split("\n")[1..-1] || []).map { |line| line.split[1] }
    # TODO need to use $COMP_LINE as a colon (e.g. foo:TABTAB) starts a new token, and hides the pre-colon text
    if current =~ /^([-\w:]+:)/
      upto_last_colon = $1
      STDERR.p upto_last_colon
      tasks = tasks.map { |t| (t =~ /^#{Regexp.escape upto_last_colon}([-\w:]+)$/) ? "#{$1}" : t }
    end
    tasks
  end
  c.flags :silence, :s
  c.flags :trace, :t
end