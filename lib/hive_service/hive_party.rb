# frozen_string_literal: true

require 'httparty'

module HiveService
  # Utility class that we use to send API requests to the HIVE server
  class HiveParty
    include HTTParty

    def initialize(opts = {})
      @base_uri = opts.fetch(:base_uri, 'https://hive.explo.org')
      @hive_token = ENV['HIVE_API_TOKEN'] || opts.fetch(:hive_token)
    end

    # POST a request to HIVE.
    # @param endpoint [String] Which endpoint of the HIVE API do you want to
    #   hit?
    # @param form_data [Hash] The form data you wish to POST.
    #
    # @return [Array] A list of HiveAtom objects
    def post(endpoint, form_data)
      form_data = form_data.merge(token: @hive_token)
      response = self.class.post(
        endpoint,
        body: form_data.to_json,
        headers: { 'Content-Type' => 'application/json' },
        base_uri: @base_uri
      )

      parse_response response
    end

    private

    def parse_response(response)
      if response.success? && response.body
        case json = JSON.parse(response.body)
        when Array
          json.map { |a| HiveAtom.new(a) }
        when Hash
          HiveAtom.new(json)
        end
      else
        response.parsed_response['data']
      end
    end
  end
end
