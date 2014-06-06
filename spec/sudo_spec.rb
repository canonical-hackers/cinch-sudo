require 'spec_helper'

# I need to add support for non triggered actions to cinch-test,
# so this will have to do.
def sudo_command(command = '/bin/echo foo', pass = true)
  "Jun  3 17:32:16 localhost sudo: username : "\
  "#{pass ? '' : '3 incorrect password attempts ; '}"\
  "TTY=ttys007 ; "\
  "PWD=/Users/username ; "\
  "USER=root ; "\
  "COMMAND=#{command}"
end

describe Cinch::Plugins::Sudo do
  include Cinch::Test

  it 'should recognize correct sudo lines' do
    entry = Cinch::Plugins::Sudo::Entry.new(sudo_command)
    expect(entry).to_not be nil
  end

  it 'should marke entries successful' do
    entry = Cinch::Plugins::Sudo::Entry.new(sudo_command)
    expect(entry.success).to be true
  end
end
