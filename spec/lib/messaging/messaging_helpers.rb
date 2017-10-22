require 'messaging/script'

module Messaging
  module MessagingHelpers
    def fixture_file(name)
      File.open(File.join(File.dirname(__FILE__), 'fixtures', "#{name}.json"))
    end

    def load_script(name)
      Script.from_file(fixture_file(name))
    end

    def load_message(script_name, message_id)
      load_script(script_name).find_message(message_id)
    end
  end
end

class TestCommandProcessor
  def initialize
    @commands = []
  end

  def received_commands
    @commands
  end

  def process_command_named(name, input, _context)
    @commands << [name, input]
  end
end
