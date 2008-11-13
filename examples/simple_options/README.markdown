Example of Ezy Bash Completions for Simple Options definition
-------------------------------------------------------------

myapp -TAB     => would show all options
myapp --TAB    => would show all long-name options
myapp --verTAB => would show all options starting with --ver
myapp TAB      => would default to normal environment behaviour

Setup
=====

    EzyAutoCompletion.config do |c|
      c.simple %w[-h --help -v --version]
    end
