require 'hashie/mash'
require 'yaml'
require 'erb'

env = ENV['RACK_ENV'] || 'development'

main_config_text = ERB.new(File.read(File.join( File.dirname(__FILE__), 'application.yml' ))).result
main_config = YAML.load(main_config_text)[env]

APP_CONFIG = Hashie::Mash.new(main_config)
