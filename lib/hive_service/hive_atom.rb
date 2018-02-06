# frozen_string_literal: true

require 'date'

module HiveService
  # A representation of a single atom from the HIVE system. Contains useful
  # methods for accessing atom data such as the "triplet", the data in Ruby
  # Hash format, etc.
  class HiveAtom
    # These are the "core" fields that constitute a HIVE atom. An atom from the
    # HIVE system will have all of these, but an atom that goes INTO the HIVE
    # system need only have application, context, process (the "triplet"), and
    # data.
    FIELDS = %w[
      id application context process data receipts created_at updated_at
    ].freeze

    # Create accessors for all fields.
    FIELDS.each { |f| attr_accessor f }

    # A HIVE Atom can be initialized from a Ruby Hash (with string or symbol
    # keys), or from a JSON object with the same shape as a HIVE atom. The
    # default is to expect a Hash.
    #
    # @param atom_data [Hash] The atom details. Alternatively you can pass a
    #   JSON String.
    def initialize(atom_data = {})
      case atom_data
      when Hash
        initialize_atom_hash(atom_data)
      when String
        initialize_atom_json(atom_data)
      else
        raise ArgumentError
      end
      ensure_data_exists
    end

    # Returns creation date as a Ruby `DateTime` object.
    #
    # @return [DateTime]
    def created_at_datetime
      @created_at_datetime ||= DateTime.parse(@created_at)
    end

    # Returns updated date as a Ruby `DateTime` object.
    #
    # @return [DateTime]
    def updated_at_datetime
      @updated_at_datetime ||= DateTime.parse(@updated_at)
    end

    # Get atom data as a Ruby `Hash`
    #
    # @return [Hash] The `data` field of the atom.
    def data_hash
      @data_hash ||=
        case @data
        when String
          JSON.parse(@data)
        when Hash
          @data
        else
          {}
        end
    end

    # @return [Hash] Hash representation of the atom.
    def to_h
      FIELDS.map { |f| [f, instance_eval("@#{f}", __FILE__, __LINE__)] }.to_h
    end

    # @return [String] JSON String representation of the atom
    def to_json
      to_h.to_json
    end

    # @return [String] JSON String representation of the atom
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
      @data ||= '{}'
    end

    def initialize_atom_hash(atom_hash)
      # we're assuming that all keys in the hash will be the same type as the
      # first...
      first_key = atom_hash.keys.first
      FIELDS.each do |f|
        if first_key.is_a? Symbol
          instance_eval "@#{f} = atom_hash[:#{f}]", __FILE__, __LINE__
        elsif first_key.is_a? String
          instance_eval "@#{f} = atom_hash['#{f}']", __FILE__, __LINE__
        end
      end
    end

    def initialize_atom_json(atom_json)
      atom_hash = JSON.parse atom_json
      initialize_atom_hash(atom_hash)
    end
  end
end
