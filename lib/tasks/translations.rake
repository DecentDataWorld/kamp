require 'yaml'
require 'json'
require 'find'

namespace :translations do

  desc "generate json file"
  task generate_json: :environment do

    translations = {"en" => {}}
    Find.find("./config/locales/") do |filename|
      if filename =~ /.*\.yml$/
        locale_hash = YAML.load_file(filename)
        locale_hash["en"].each do |key, value|
          puts key
          puts value
          translations["en"][key] = value
        end
      end
    end

    File.open("./app/javascript/i18n-js/translations.json","w") do |f|
      f.write(translations.to_json)
    end
  end

end
