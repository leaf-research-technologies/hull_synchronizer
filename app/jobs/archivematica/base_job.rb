module Archivematica
  # BaseJob for all Archivematica jobs.
  class BaseJob < Gush::Job
    require 'archivematica/api'
    attr_reader :response

    def perform
      raise NotImplementedError, 'Use one of the subclasses of BaseJob'
    end

    private

      delegate :status, to: :response

      # Return the response body
      # @return [Hash] the response body
      def body
        JSON.parse(response.body) unless response.body.nil?
      rescue JSON::ParserError
        ''
      end

      # If response code is 200, continue
      def act_on_status
        if status == 200
          act_on_ok
        else
          output(event: 'failed', message: message_text)
          fail!
        end
      end

      # Create a message for return with the job
      # @return [String] message
      def message_text
        if body.is_a?(Hash) && body.key?('message')
          body['message']
        else
          response.reason_phrase
        end
      end
  end
end