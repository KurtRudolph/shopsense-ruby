gem 'rspec';    require 'rspec/core/rake_task'
gem 'highline'; require 'highline/import'
gem 'yard';     require 'yard'

RSpec::Core::RakeTask.new('spec')

YARD::Rake::YardocTask.new('yard')

desc "Run all tasks"
task :default => [:spec]






#an attempt at dynamically inserting documentation into the gh-pages branch

=begin
task :gh_pages do
  return if !agree( "The following will sync and update the submodule of this project, generate the user rdoc of the project into the gh-pages submodule, and git add/commit/push all changes to the origin.  Do you wish to continue? ")
  `git submodule sync -- doc/gh-pages`
  `git submodule update -- doc/gh-pages`
  Dir.chdir( 'doc/gh-pages') {`git checkout -t origin/gh-pages`}
  `rake rdoc_gh_pages`
  `cp -r doc/temp/* doc/gh-pages/`
  `rm -r -f doc/temp/`
  Dir.chdir( 'doc/gh-pages') do
    `git add .`
    `git commit -m "Automated 'rake gh_pages' update"`
    `git push origin gh-pages`
  end
end
=end