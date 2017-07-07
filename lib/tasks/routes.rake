desc "Prints routes"
task :routes do
  require_relative '../../environment'

  require 'main'

  Api::Main.routes.each do |route|
    puts "version=#{route.options[:version]}, method=#{route.options[:method]}, path=#{route.pattern.origin}"
  end
end

