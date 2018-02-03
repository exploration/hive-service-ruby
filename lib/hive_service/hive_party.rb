require 'httparty'

module HiveService
  # Utility class that we use to send requests to the HIVE server
  class HiveParty
    include HTTParty

    def initialize(opts = {})
      #self.class.base_uri(opts.fetch(base_uri, 'https://hive.explo.org'))
      @base_uri = opts.fetch(:base_uri, 'https://hive.explo.org')
      @hive_token = ENV['HIVE_API_TOKEN'] || opts.fetch(:hive_token)
    end

    # POST a request to HIVE.
    # @param endpoint [String] Which endpoing of the HIVE api do you want to hit?
    # @param form_data [Hash] The form data you wish to POST.
    #
    # @return [Array] A list of HiveAtom objects
    def post(endpoint, form_data)
      form_data = form_data.merge(token: @hive_token)
      response = self.class.post(
        endpoint,
        query: form_data,
        headers: {"Content-Type" => "x-www-form-urlencoded"},
        base_uri: @base_uri
      )
      if response.success?
        json = JSON.parse(response.body)
        case json
        when Array
          json.map{|a| HiveAtom.new(a)}
        when Hash
          HiveAtom.new(json)
        end
      else
        # Silence errors, return nothing.
        []
      end 
    end
  end
end
