require 'ostruct'
require 'yaml'
file = Rails.root.join('config/mygithub.yml')
if File.exist?(file)
  AppConfig = OpenStruct.new(YAML.load_file(Rails.root.join('config/mygithub.yml'))[Rails.env])
else
  raise ArgumentError.new('you need define your mygithub.yml file')
end
