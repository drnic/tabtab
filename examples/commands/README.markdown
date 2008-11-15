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
      c.flags %w[-h --help -v --version]
      c.command :help
      c.command :run do
        `myapp --available`
      end
    end

    # github
    c.flag "-h", "--help"
    # github home 
    c.command :home, "Open this repo's master branch in a web browser." 
    # github pull dchelisky
    # github pull --merge dchelisky
    # github pull dchelisky --merge
    c.command :pull, "Pull from a remote.", %w[--merge] do
      `github network list`
    end

    c.command :fetch, "Fetch from a remote to a local branch."
    c.command :"pull-request" 
    c.command :browse
    # github pull dchelisky
    # github pull --merge dchelisky
    # github pull dchelisky --merge
    c.command :pull, "Pull from a remote." do
      default ''
      command :asd do

      end
      cmd.default do
        `github network list`
      end
      cmd.flag :merge, :m, "asdfasdf" {
        `things to merge`
      }
    end
    c.command :pull, "Pull from a remote." do
      `github network list`.split(/\n/)
    end
    # github network list
    # github network --cache list
    # github network --sort branch list --reverse
    # github network --sort branch --cache list
    # github network --author some@one.com --before 2008-10-08 list
    c.command :network, "Project network tools" do |network|
      network.command :web do |web|
        web.flag :reverse
      end
      network.command :list do |list|
        list.flag :reverse
      end
      network.command :fetch, "adsfdsaf" do |fetch|
        fetch_commands fetch
      end
      network.command :fetch2, "asdf" do |fetch|
        fetch_commands fetch
      end
      network.command :commits
      network.flag :author, :a do
        # some_list_of_author_emails
      end
      network.flag :cache
    end
    # github clone dchelimsky/rspec
    c.command :clone, "Clone a repo.", %w[--ssh]
    c.command :ignore       
    c.command :track
    c.command :info         
    c.command :fetch_all

    c.default do
      show_list_of_command
    end

# Testing helper

    assert_completable_to "github network --sort branch list --reverse"    