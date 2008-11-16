%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/ezy_auto_completions'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('ezy_auto_completions', EzyAutoCompletions::VERSION) do |p|
  p.developer('Dr Nic Williams', 'drnicwilliams@gmail.com')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.post_install_message = 'PostInstall.txt'
  # p.extra_deps         = [
  #   ['activesupport','>= 2.0.2'],
  # ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

remove_task :default
task :default => [:spec, :features]
