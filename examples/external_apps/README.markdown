Example of Ezy Bash Completions with External Apps
--------------------------------------------------

Many applications have a simple set of options that
can be viewed via a -h/--help/-? option. For example:

    $ rails -h
    Usage: /usr/bin/rails /path/to/your/app [options]
        -r, --ruby=path
        -d, --database=name
        -f, --freeze
    etc

It is possible to configure your environment to automatically
provide autocompletions for such applications.

In your .bash_profile add the following to activate auto-completions for RubyGem apps:

    ezy_auto_completions
    
Now, create a .ezy\_auto_completions file, with content:

    external: 
      --help: 
      - rails
      - rake
      -?: 
      - some_app
      - another_app

Application names are in lists (rails, rake) and (some\_app, another\_app), with keys '--help' and '-?'.
The key is the option to use for each app to get a run-time printout of the options for that app.

## Sample --help outputs

Options are displayed in various, mostly-similar formats. Below are samples of options from
different applications.

Samples from below are used in the unit test/examples.

### rake

    Options are ...
        -C, --classic-namespace          Put Task and FileTask in the top level namespace
        -D, --describe [PATTERN]         Describe the tasks (matching optional PATTERN), then exit.
        -e, --execute CODE               Execute some Ruby code and exit.
        -p, --execute-print CODE         Execute some Ruby code, print the result, then exit.
        -P, --prereqs                    Display the tasks and dependencies, then exit.
            --rakelib
        -G, --no-system, --nosystem      Use standard project Rakefile search paths, ignore system wide rakefiles.
        -h, -H, --help                   Display this help message.

### rails

    Usage: /usr/bin/rails /path/to/your/app [options]

    Options:
        -r, --ruby=path                  Path to the Ruby binary of your choice (otherwise scripts use env, dispatchers current path).
                                         Default: /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
        -d, --database=name              Preconfigure for selected database (options: mysql/oracle/postgresql/sqlite2/sqlite3/frontbase/ibm_db).
                                         Default: sqlite3
        -f, --freeze                     Freeze Rails in vendor/rails from the gems generating the skeleton
                                         Default: false

### newgem

    Options:
        -b=BIN_NAME[,BIN_NAME2]          Sets up executable scripts in the bin folder.
            --bin-name                   Default: none

