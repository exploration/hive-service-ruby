# frozen_string_literal: true

module HiveService
  # A handy service you can use to push or pull atoms from HIVE!
  class HiveService
    attr_accessor :application_name, :hive_base_uri

    # @option opts [String] :application_name (Required) Name of application
    #   that's making HIVE requests
    # @option opts [String] :hive_token (Required) Authentication token for
    #   HIVE. Checks ENV for HIVE_API_TOKEN as well.
    # @option opts [String] :hive_base_uri Which HIVE server to point to.
    #   Defaults to 'https://hive.explo.org'.
    def initialize(opts = {})
      @application_name = opts.fetch :application_name
      @hive_token = opts.fetch(:hive_token, ENV['HIVE_API_TOKEN'])

      @hive_base_uri = opts.fetch :hive_base_uri, 'https://hive.explo.org'
      @hive_party = HiveParty.new(
        base_uri: @hive_base_uri,
        hive_token: @hive_token
      )
    end

    # Return an array of HiveAtoms, that match a given application, context,
    # and process.
    #
    # @option opts [String] :application (Required) Name of application to
    #   match
    # @option opts [String] :context Name of context to match
    # @option opts [String] :process Name of process to match
    # @option opts [String] :receipts Show atoms not-received-by this
    #   application
    #
    # Example:
    #
    #     service.get_unseen_atoms("donald", "testing", "search",
    #       "unseen_by_this_app")
    #     -> [HiveAtom<>, HiveAtom<>, etc...]
    def get_unseen_atoms(opts = {})
      @hive_party.post('/atom_search', opts) unless opts[:application].nil?
    end

    # POST a new atom to HIVE
    #
    # @param atom [HiveService::HiveAtom] the atom to post
    def post(atom)
      @hive_party.post '/atoms', atom.to_h
    end

    # Mark a particular atom as being received by the application associated
    # with this HiveService.
    #
    # @param atom [HiveService::HiveAtom] the atom we're receiving
    def post_receipt(atom)
      form_data = { application: @application_name }
      @hive_party.post "/atoms/#{atom.id}/receipts", form_data
    end

    # Remove a given atom from HIVE entirely
    #
    # @param atom [HiveService::HiveAtom] the atom we're deleting
    def delete(atom)
      form_data = { atom_id: atom.id }
      @hive_party.post "/atoms/#{atom.id}/deletions", form_data
    end
  end
end
