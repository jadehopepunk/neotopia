require_relative 'script'
require_relative 'interpolator'

module Messaging
  class Exchange
    def initialize(script:, context: nil)
      @script = script
      @context = context
      @interpolator = Interpolator.new(context)
      @previous_message = nil
      @input = nil
      @response_message = nil
    end

    def user_input(to:, input:)
      @previous_message = script.find_message(to)
      @input = input
    end

    def determine_response
      target = script.transition_for_input input: input, previous: previous_message
      @response_message = script.message_for_transition target
    end

    def process_commands(command_processor)
      return unless previous_message

      previous_message.command_names.each do |command_name|
        command_processor.process_command_named command_name, input, context
      end
    end

    def as_json
      {
        message: response_message.as_json(interpolator),
        data: (context ? context.as_json : {})
      }
    end

    private

    attr_reader :script, :previous_message, :response_message, :input,
                :context, :interpolator
  end
end
