Example of Ezy Bash Completions for Commands
--------------------------------------------

myapp -TAB     => would show all options
myapp --TAB    => would show all long-name options
myapp --verTAB => would show options starting with '--ver'
myapp TAB      => would show all commands
myapp heTAB    => would show commands starting with 'he'
myapp run -TAB => would show options for 'run' command
                  e.g. -h --help -p --port, but not --version

Setup
=====

    EzyAutoCompletion.config do |c|
      c.simple %w[-h --help -v --version]
      c.commands(
        :help => [],
        :run  => %w[-h --help -p --port]
      )
    end
