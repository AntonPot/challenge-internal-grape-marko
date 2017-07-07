$:.push(File.join(File.dirname(__FILE__), 'app/'))

require 'active_record'
require_relative 'config/app_config'
require 'models/database_url_builder'


ActiveRecord::Base.establish_connection(DatabaseUrlBuilder.build)
ActiveRecord::Base.default_timezone = :utc
