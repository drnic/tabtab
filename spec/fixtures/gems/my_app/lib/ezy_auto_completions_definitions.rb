EzyAutoCompletions::Definition.register('test_app') do |c|
  c.flags :help, :h
  c.flags :extra, :x
  c.command :shell
  c.command :do do
    %w[run start end]
  end
  c.command :here do |here|
    here.flag :funny, :f
    here.command :we do |we|
      we.default do
        `git branch | sed -e "s/..//"`.split(/\n/)  
      end
    end
  end
end