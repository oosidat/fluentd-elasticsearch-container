require 'json'

module Fluent
  class TextParser
    class JsonInStringParser < Parser
      Plugin.register_parser("json_in_string", self)

      config_param :time_format, :string, :default => nil # time_format is configurable

      def configure(conf)
        super
        @time_parser = TimeParser.new(@time_format)
      end

      # This is the main method. The input is the unit of data to be parsed.
      # If this is the in_tail plugin, it would be a line. If this is for in_syslog,
      # it is a single syslog message.
      def parse(input)
        begin
          output = (input.is_a?(Hash)) ? (input) : (JSON.parse(input))
          time = @time_parser.parse(output['time'])
          yield time, output
        rescue
          yield input
        end
      end
    end
  end
end
