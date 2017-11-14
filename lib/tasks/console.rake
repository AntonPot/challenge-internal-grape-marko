desc "Runs a console with the application loaded"
task :console do
  $:.push(File.join(File.dirname(__FILE__), '../../'))

  require_relative '../../environment'
  require 'irb'
  require 'irb/completion'
  require 'awesome_print'

  loadDependency = lambda { |location|
    Dir["app/#{location}/**/*.rb"].each {|file|
      require file
    }
  }

  require 'app/main'

  loadDependency.call(:api)
  loadDependency.call(:models)

  ActiveRecord::Base.logger = Logger.new(STDOUT)
  
  AwesomePrint.irb!
  ARGV.clear
  IRB.start
end



