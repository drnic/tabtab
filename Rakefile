require "bundler/setup"
Bundler::GemHelper.install_tasks

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--color']
end

task :test => :spec

require 'cucumber/rake/task'

namespace :cucumber do
  Cucumber::Rake::Task.new(:ok) do |t|
    t.cucumber_opts = "--format progress"
  end
end


desc "Run specs as default activity"
task :default => ["spec", "cucumber:ok"]
