require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EzyAutoCompletions::ExtractHelpOptions, "extract" do
  before(:each) do
    options_str = <<-EOS.gsub(/^    /, '')
    Options are ...
        -C, --classic-namespace          Put Task and FileTask in the top level namespace
        -D, --describe [PATTERN]         Describe the tasks (matching optional PATTERN), then exit.
        -e, --execute CODE               Execute some Ruby code and exit.
        -p, --execute-print CODE         Execute some Ruby code, print the result, then exit.
        -P, --prereqs                    Display the tasks and dependencies, then exit.
            --rakelib
        -G, --no-system, --nosystem      Use standard project Rakefile search paths, ignore system wide rakefiles.
        -h, -H, --help                   Display this help message.

    Options:
        -r, --ruby=path                  Path to the Ruby binary of your choice (otherwise scripts use env, dispatchers current path).
                                         Default: /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
        -d, --database=name              Preconfigure for selected database (options: mysql/oracle/postgresql/sqlite2/sqlite3/frontbase/ibm_db).
                                         Default: sqlite3
        -f, --freeze                     Freeze Rails in vendor/rails from the gems generating the skeleton
                                         Default: false

     Options:
         -b=BIN_NAME[,BIN_NAME2]          Sets up executable scripts in the bin folder.
             --bin-name                   Default: none
    EOS
    @options = EzyAutoCompletions::ExtractHelpOptions.new(options_str)
  end
  
  it "should find all options" do
    long_options  = %w[--bin-name --classic-namespace --database --describe --execute] +
                    %w[--execute-print --freeze --prereqs --rakelib --ruby]
    short_options = %w[-b -d -e -f -p -r -C -D -P]
    expected      = long_options + short_options
    @options.extract.should == expected
  end
end
