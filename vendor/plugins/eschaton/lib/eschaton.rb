require "#{File.dirname(__FILE__)}/eschaton/eschaton"

# Added for linux distros and to prevet production errors
require "#{File.dirname(__FILE__)}/eschaton/script_store"
require "#{File.dirname(__FILE__)}/eschaton/helpers/readable_attributes"
require "#{File.dirname(__FILE__)}/eschaton/javascript/javascript_object"

Dir["#{File.dirname(__FILE__)}/eschaton/**/*.rb"].each do |file|
  Eschaton.dependencies.require file
end

Eschaton::SliceLoader.load