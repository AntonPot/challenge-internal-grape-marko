require 'active_record_migrations'
require_relative 'config/app_config'

import *Dir.glob('lib/tasks/**/*.rake')

#begin
#  uri = URI.parse(APP_CONFIG.database_url)
#rescue URI::InvalidURIError
#  raise "Invalid DATABASE_URL"
#end
#
#adapter = uri.scheme
#adapter = 'postgresql'
#database = APP_CONFIG.database
#username = APP_CONFIG.user
#password = APP_CONFIG.password
#host = APP_CONFIG.host
#port = APP_CONFIG.port
#environment = ENV['RACK_ENV'].nil? ? 'development' : ENV['RACK_ENV']

#ActiveRecord::Base.establish_connection(uri.to_s)

ActiveRecordMigrations.configure do |c|
  c.database_configuration = {
    environment => {
      'adapter' => APP_CONFIG.fetch(:adapter),
      'database' => APP_CONFIG.fetch(:database),
      'username' => APP_CONFIG.fetch(:username),
      'password' => APP_CONFIG.fetch(:password),
      'host' => APP_CONFIG.fetch(:host),
      'port' => APP_CONFIG.fetch(:port)
    }
  }

  c.schema_format = :ruby
end

ActiveRecordMigrations.load_tasks
