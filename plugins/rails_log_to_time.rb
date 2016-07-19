require 'json'

module Fluent
  class TextParser
    class RailsLogToTimeParser < Parser
      Plugin.register_parser("rails_log_to_time", self)

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
          output = /(\d{4})-(\d{2})-(\d{2})( |T)*(\d{2}):(\d{2}):(\d{2}).(\d{3,})/.match(input).to_s
          output = output.gsub(" ", "T")
          time = @time_parser.parse(output)
          yield time, output
        rescue
          yield input
        end
      end
    end
  end
end
