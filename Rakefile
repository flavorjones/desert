require "rake"
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Runs the Rspec suite"
task :default do
  run_suite
end

desc "Runs the Rspec suite"
task :spec do
  run_suite
end

def run_suite
  dir = File.dirname(__FILE__)
  system("ruby #{dir}/spec/spec_suite.rb") || raise("Example Suite failed")
end

begin
  gem "pivotal-jeweler"
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "desert"
    s.summary = "Desert is a component framework for Rails that allows your plugins to be packaged as mini Rails apps."
    s.email = "opensource@pivotallabs.com"
    s.homepage = "http://pivotallabs.com"
    s.description = "Desert is a component framework for Rails that allows your plugins to be packaged as mini Rails apps."
    s.authors = ["Pivotal Labs", "Brian Takita", "Parker Thompson", "Adam Milligan, Joe Moore"]
    s.files =  FileList[
      '[A-Z]*',
      '*.rb',
      'lib/**/*.rb',
      'generators/**/*',
      'generators/**/templates/*',
      'examples/**/*.rb'
    ].to_a
    s.extra_rdoc_files = [ "README.rdoc", "CHANGES" ]
    s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]
    s.test_files = Dir.glob('spec/*_spec.rb')
    s.rubyforge_project = "desert"
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

task :work_around_jewelers_annoying_helpfulness do
  ENV["GIT_DIR"] = nil
  ENV["GIT_WORK_TREE"] = nil
  ENV["GIT_INDEX_FILE"] = nil
end

desc "Install dependencies to run the build. This task uses Git."
task :install_dependencies => :work_around_jewelers_annoying_helpfulness do
  require "lib/desert/supported_rails_versions"
  FileUtils.mkdir_p "spec/rails_root/vendor/rails_versions"
  unless File.exists? "spec/rails_root/vendor/rails_versions/edge"
    system("git clone git://github.com/rails/rails.git spec/rails_root/vendor/rails_versions/edge")
  end
  Dir.chdir("spec/rails_root/vendor/rails_versions/edge") do
    begin
      Desert::SUPPORTED_RAILS_VERSIONS.each do |version, data|
        next if version == 'edge'
        next if File.exists?("../#{version}")
        system("pwd && git checkout #{data['git_tag']}")
        system("cp -lR ../edge ../#{version}")
      end
    ensure
      system("git checkout master")
    end
  end
end

desc "Updates the dependencies to run the build. This task uses Git."
task :update_dependencies => :work_around_jewelers_annoying_helpfulness do
  Dir.chdir "spec/rails_root/vendor/rails_versions/edge" do
    system "git pull origin"
  end
end

desc "Runs the CI build"
task :cruise => :install_dependencies do
  run_suite
end
