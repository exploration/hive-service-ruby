require 'date'
require 'json'

module HiveService
  class HiveAtom
    FIELDS = [
      'id',
      'application',
      'context',
      'process',
      'data',
      'receipts',
      'created_at',
      'updated_at'
    ]

    FIELDS.each {|f| attr_accessor f}

    # We always initialize a HIVE atom from a JSON string (because we're using
    # this class mostly to parse incoming atoms rather than to send outgoing
    # ones)
    def initialize(atom_data = {})
      if atom_data.kind_of? Hash
        initialize_atom_hash(atom_data)
      elsif atom_data.kind_of? String
        initialize_atom_json(atom_data)
      else
        raise ArgumentError
      end

      ensure_data_exists
    end

    def created_at_datetime
      @created_at_datetime ||= DateTime.parse(@created_at)
    end

    def updated_at_datetime
      @updated_at_datetime ||= DateTime.parse(@updated_at)
    end

    # We rarely want the data as JSON text in Ruby. So by default, we return the
    # parsed hash of the data instead.
    def data_hash
      @data_hash ||= JSON.parse(@data)
    end

    def to_h
      FIELDS.map {|f| [f, instance_eval("@#{f}")] }.to_h
    end

    def to_json
      to_h.to_json
    end

    def to_s
      to_json
    end

    # In HIVE-parlance, a "triplet" is where the data originated, represented as
    # a 3-element value: application, context, and process. This version returns
    # a 3-element array: [application, context, process].
    def triplet
      [@application, @context, @process]
    end

    private

    def ensure_data_exists
      @data ||= "{}"
    end

    def initialize_atom_hash(atom_hash)
      # we're assuming that all keys in the hash will be the same type as the
      # first...
      first_key = atom_hash.keys.first
      FIELDS.each do |f|
        if first_key.is_a? Symbol
          instance_eval "@#{f} = atom_hash[:#{f}]"
        elsif first_key.is_a? String
          instance_eval "@#{f} = atom_hash['#{f}']"
        end
      end      
    end

    def initialize_atom_json(atom_json)
      atom_hash = JSON.parse atom_json
      initialize_atom_hash(atom_hash)
    end
  end
end
