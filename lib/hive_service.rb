require "hive_service/version"
require "hive_service/hive_atom"

module HiveService
  class HiveService

    attr_reader :application_name, :hive_base_url, :hive_token

    HIVE_BASE_URL = "https://hive.explo.org"
    HIVE_TOKEN = ENV['HIVE_API_TOKEN']

    def initialize(options = {})
      @hive_base_url = options.fetch :hive_base_url, 'https://hive.explo.org'
      @hive_token = options.fetch :hive_token)
      @application_name = options.fetch :application_name
    end

    # returns a hash representing all un-seen HIVE objects matching a given
    # application, context, and process
    def get_unseen_atoms(
        application, context = nil, process = nil, receipts = @application_name
    )
      form_data = { 
        receipts: receipts,
        application: application 
      }
      form_data.merge!(context: context) unless context.nil?
      form_data.merge!(process: process) unless process.nil?
      
      post "/atom_search", form_data
    end

    # given an object with an "attributes" method that returns a hash, convert it
    # to a JSON representation + post that to the HIVE system
    def self.post_atom(context, process, object, portico_id=nil)
      portico_id = object.try(:requirement).try(:user).try(:portico_id) if portico_id == nil
      form_data = object.attributes.merge({ portico_id: portico_id }).to_json
      form_data = {
        application: @application_name,
        context: context,
        process: process,
        data: form_data
      }
      post "/atoms", form_data
    end

    # mark a particular atom as being received by the portal
    def self.post_receipt(atom_id)
      form_data = { application: @application_name }
      post "/atoms/#{atom_id}/receipts", form_data
    end

    # remove a given atom
    def self.delete(atom_id)
      form_data = { atom_id: atom_id }
      post "/atoms/#{atom_id}/deletion", form_data
    end


    private

    # POST to a given HIVE URI, given an API-valid uri_string
    # returns either the (JSON) result of the API call, or nil if there was no result
    def self.post(uri_string, form_data=nil)
      form_data.merge!(token: @hive_token)
      uri = URI(URI.escape("#{@hive_base_url}#{uri_string}"))

      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new uri.request_uri
        request['Content-Type'] = 'application/json'
        request.set_form_data form_data unless form_data.nil?

        response = http.request request # Net::HTTPResponse object
        result = nil

        begin
          result = JSON.parse(response.try(:body))
        rescue
          Rails.logger.error "HIVE service POST: JSON parse error: #{response.inspect}"
        end

        return result
      end
    end
  end
end
