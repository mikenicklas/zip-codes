require 'yaml'

module ZipCodes
  VERSION = '0.2.1'

  class << self
    def identify(code)
      db[code]
    end

    def identify_by_city_and_state_name(options = {})
      # set default value if no match is found
      zip = nil

      # make values case insensitive
      state_name = format_option(options[:state_name])
      city = format_option(options[:city])

      # returns the zip code of the first matching city and state_name record
      db.each do |key, value|
        if value[:city].downcase == city && value[:state_name].downcase == state_name
          # return current key (zip code) and break loop
          # when the first match is found
          zip = key
          break
        end
      end

      # return zip as nil or the zip code that was assigned during the loop
      zip
    end

    def db
      @db ||= begin
        this_file = File.expand_path(File.dirname(__FILE__))
        us_data = File.join(this_file, 'data', 'US.yml')
        YAML.load(File.open(us_data))
      end
    end

    def load
      db
    end

    def find(options)
      identify_by_city_and_state_name(options)
    end

    def format_option(option)
      option.downcase unless option.nil?
    end
  end
end
