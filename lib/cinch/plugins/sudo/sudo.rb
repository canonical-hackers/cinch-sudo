require 'file-tail'

module Cinch::Plugins
  class Sudo
    include Cinch::Plugin

    listen_to :channel

    def initialize(*args)
      super
      @date_re = Regexp.new(/^(\w{3}\s+\d+\s+\d{2}:\d{2}:\d{2})\s+/)
      @user_re = Regexp.new(/^sudo:\s+(\w+)\s+: /)
      @sudo_re = Regexp.new(/^\w{3}\s+\d+\s+\d{2}:\d{2}:\d{2}\s+\w+\s+sudo:\s+(\w+)\s+:/)
      @results_struct = Struct.new(:date, :user, :tty, :pwd, :executed_as, :command, :success)
      @sudoconfig = YAML::load(File.open('config/sudo.yml'))
    end

    def listen(m)
      logfile = @sudoconfig['logfile']

      File::Tail::Logfile.tail(logfile) do |line|
        if looks_like_sudo? line
          m.reply format_results(process_line(line.chomp))
        end
      end
    end

    private

    def format_results(results)
      if results.success == true
        "#{results.date}: #{results.user} ran (#{results.command}) as #{results.executed_as} in (#{results.pwd})"
      else
        "#{results.date}: #{results.user} tried to run (#{results.command}) as #{results.executed_as} in (#{results.pwd}), but failed (incorrect password?)"
      end
    end

    def looks_like_sudo?(line)
      line.match(@sudo_re)
    end

    def process_line(line)
      results = @results_struct.new
      results.date = line.match(@date_re)[1] || "(unknown timestamp)"
      line.gsub!(@date_re, "")

      # remove hostname
      line.gsub!(/^\w+\s/, "")

      # extract user
      results.user = line.match(@user_re)[1]
      line.gsub!(@user_re, '')

      sudo_fields = line.split(/\s+;\s+/).map {|chunk| chunk.split(/=/)[1]}

      if sudo_fields.length == 4
        results.tty = sudo_fields[0]
        results.pwd = sudo_fields[1]
        results.executed_as = sudo_fields[2]
        results.command = sudo_fields[3]
        results.success = true
      else
        results.success = false
        results.tty = sudo_fields[1]
        results.pwd = sudo_fields[2]
        results.executed_as = sudo_fields[3]
        results.command = sudo_fields[4]
      end

      results
    end
  end
end
