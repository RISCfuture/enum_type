require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
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
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'yard'
YARD::Rake::YardocTask.new('doc') do |doc|
  doc.options << "-m" << "textile"
  doc.options << "--protected"
  doc.options << "-r" << "README.textile"
  doc.options << "-o" << "doc"
  doc.options << "--title" << "enum_type Documentation"
  
  doc.files = [ 'lib/**/*', 'README.textile' ]
end

task(default: :spec)
