require "bundler/setup"
Bundler::GemHelper.install_tasks

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--color']
end

task :test => :spec

desc "Run specs as default activity"
task :default => [:spec, :cucumber]
