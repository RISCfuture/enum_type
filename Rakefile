require 'rake'
begin
  require 'bundler'
rescue LoadError
  puts "Bundler is not installed; install with `gem install bundler`."
  exit 1
end

Bundler.require :default

Jeweler::Tasks.new do |gem|
  gem.name = "enum_type"
  gem.summary = %Q{PostgreSQL enumerated types in ActiveRecord}
  gem.description = %Q{Allows ActiveRecord to better use PostgreSQL's ENUM types.}
  gem.email = "git@timothymorgan.info"
  gem.homepage = "http://github.com/riscfuture/enum_type"
  gem.authors = [ "Tim Morgan" ]
  gem.required_ruby_version = '>= 1.9'
  gem.add_dependency "activerecord", ">= 0"
end
Jeweler::GemcutterTasks.new

desc "Build API documentation"
YARD::Rake::YardocTask.new('doc') do |doc|
  doc.options << "-m" << "textile"
  doc.options << "--protected"
  doc.options << "-r" << "README.textile"
  doc.options << "-o" << "doc"
  doc.options << "--title" << "enum_type Documentation".inspect
  
  doc.files = [ 'lib/**/*', 'README.textile' ]
end

require 'rspec/core/rake_task'

desc 'Run all RSpecs'
task(default: :spec)

desc 'Run all RSpecs'
RSpec::Core::RakeTask.new

desc "Generate code coverage"
RSpec::Core::RakeTask.new(:coverage) do |t|
  t.rcov = true
  t.rcov_opts = %w( --exclude spec )
end
