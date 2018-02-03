# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new

desc 'After you\'ve done work, run this to check tests, Rubocop, and Yard' \
     'compliance'
task check_all: %i[test rubocop yard]

task default: :check_all
