Example of Ezy Bash Completions with Algorithmic Arguments
----------------------------------------------------------

myapp -TAB        => would show all options
myapp --TAB       => would show all long-name options
myapp --verTAB    => would show options starting with '--ver'
myapp TAB         => would show all commands
myapp heTAB       => would show commands starting with 'he'
myapp run -TAB    => would show options for 'run' command
                  e.g. -h --help -p --port, but not --version
myapp stop -p TAB => would show possible port numbers to stop
myapp install TAB => would show list of things to install
                  e.g. foo bar tar


Setup
=====

    EzyAutoCompletion.config do |c|
      c.simple %w[-h --help -v --version]
      c.commands(
        :help => [],
        :run  => %w[-h --help -p --port],
        :stop => {
          %w[-p --port] => lambda {
            `my_app list_running_ports`.split(" ")
          }
        },
        :install => {
          :default => lambda {
            %w[foo bar tar]
          }
        }
      )
    end

NOTE: the results of `my_app installable_list` would need to be a string of space-separated options; but the lambda block needs to return an array of strings, or another hash of hierarchical completion info.

