require 'cinch'
require 'file-tail'

module Cinch
  module Plugins
    class Sudo
      include Cinch::Plugin

      listen_to :connect

      def initialize(*args)
        super
        @logfile = config[:logfile]
        @channel = config[:channel]
      end

      def listen(m)
        if File.exist?(@logfile)
          start_tail
        else
          debug "File (#{@filename}) not found!"
        end
      end

      private

      def start_tail
        File.open(@logfile) do |log|
          log.extend(File::Tail)
          log.interval = 3
          log.backward(0)
          log.tail do |line|
            entry = Entry.new(line)
            next unless entry.valid?
            Channel(@channel).send entry.to_text
          end
        end
      end
    end
  end
end
