TabTab::Definition.register('github') do |c|
  def users
    `github info | grep "^ -" | sed -e "s/ - //" | sed -e "s/ .*$//"`.split("\n")
  end
  def commits
    `github network commits 2> /dev/null | sed -e "s/ .*$//"`.split("\n")
  end
  c.flag :help, :h
  c.command(:fetch, "Fetch from a remote to a local branch.") { users }
  c.command(:"pull-request", "Generate the text for a pull request.") { users }
  c.command :browse, "Open this repo in a web browser."
  c.command :pull, "Pull from a remote." do |pull|
    pull.default { users }
    pull.flag :merge
  end
  # github network list
  # github network --cache list
  # github network --sort branch list --reverse
  # github network --sort branch --cache list
  # github network --author some@one.com --before 2008-10-08 list
  c.command :network, "Project network tools" do |network|
    network.command(:web) { user_list }
    network.command :list
    network.command :commits
    network.flag :nocache
    network.flag :cache
    network.flag :project
    network.flag(:sort) { %w[date branch author] }
    network.flag :applies
    network.flag :before
    network.flag :after
    network.flag :shas
    network.flag :author
    network.flag :common
  end
  c.command :clone, "Clone a repo." do |clone|
    clone.flag :ssh
  end
  c.command :home, "Open this repo's master branch in a web browser."
  c.command(:ignore) { commits }
  c.command :track do |track|
    track.flag :ssh
    track.flag :private
    track.default { users }
  end
  c.command :info         
  c.command(:fetch_all) { users }
end

