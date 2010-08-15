require 'active_record'

if defined?(ENV['RACK_ENV']) && ENV['RACK_ENV'] == "production"
 dbconfig = YAML.load(File.read('config/database.yml'))
 ActiveRecord::Base.establish_connection dbconfig['production']
else
 dbconfig = YAML.load(File.read("config/local-database.yml"))
 ActiveRecord::Base.establish_connection(dbconfig)
end

namespace :db do
  desc "Migrate the database"
  task(:migrate) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
