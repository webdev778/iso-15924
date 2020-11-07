require "iso-15924/version"
require "yaml"

module Iso15924
  class Error < StandardError; end

  ISO_15924 = lambda do
    yaml_file = File.expand_path('iso-15924.yaml', File.dirname(__FILE__))
    YAML.load(File.read(yaml_file)).tap do |h|
      h.each do |k,v|
        v.freeze
      end
    end
  end.call.freeze

  class << self
    def codes
      ISO_15924.keys
    end

    def valid?(code)
      codes.include? code
    end

    def data
      ISO_15924
    end
  end
end
