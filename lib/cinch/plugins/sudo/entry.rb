module Cinch
  module Plugins
    class Sudo
      class Entry
        SUDO_REGEX = /^\w{3}\s+\d+\s+\d{2}:\d{2}:\d{2}\s+[\w\.]+\s+sudo[\[\]\d]*:\s+(\w+)\s+:/
        DATE_REGEX = /^(\w{3}\s+\d+\s+\d{2}:\d{2}:\d{2})\s+/
        USER_REGEX = /sudo[\[\]\d]*:\s+(\w+)\s+:\s/
        AUTH_REGEX = /sudo[\[\]\d]*:\s+\w+\s+:\sTTY=/

        attr_accessor :date, :user, :tty, :pwd, :executedas, :command,
                      :success, :line

        def initialize(line)
          @line = line
          @date = @line[DATE_REGEX, 1] || '(unknown timestamp)'
          @user = @line[USER_REGEX, 1]

          @success = line.match(AUTH_REGEX) ? true : false

          scan_line
        end

        def valid?
          return false unless @line.match(SUDO_REGEX)
          true
        end

        def to_text
          if @success
            "#{@date}: #{@user} ran (#{@command}) as "\
            "#{@executedas} in (#{@pwd})"
          else
            "#{@date}: #{@user} tried to run (#{@command}) as #{@executedas} "\
            "in (#{@pwd}), but failed (incorrect password?)"
          end
        end

        private

        def scan_line
          vars = line.gsub(/USER=/, 'EXECUTEDAS=')
                     .scan(/ [A-Z]+=[^;\n]+/)
                     .map { |v| v.strip.split(/=/) }
          vars.each { |v, value| send("#{v.downcase}=", value) }
        end
      end
    end
  end
end
