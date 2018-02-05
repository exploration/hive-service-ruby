# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$VERBOSE=nil
require 'hive_service'
require 'minitest/autorun'
require 'rantly'
require 'rantly/minitest_extensions'

def test_atom(options = {})
  HiveService::HiveAtom.new(test_atom_hash.merge(options))
end

def test_atom_hash
  {
    application: 'test_app',
    context: 'test_context',
    process: 'test_process',
    data: %({"hello":"world"}),
    id: 1
  }
end

def test_atom_json
  test_atom_hash.to_json
end

# Sort of arbitrary data hash generator for an atom. It produces a JSON hash,
# between 1 and 100 keys in length, with either string => integer or float =>
# boolean keys.
def random_data_json
  Rantly { 
    dict(range(1,100)) {
      array(2) {
          freq [5, :string], [1, :integer], [1, :float], [1, :boolean] 
      }
    } 
  }.to_json
end

# Creates a hash with an atom shape, and entirely random values.
def random_atom_hash
  {
    application: Rantly { string },
    context: Rantly { string },
    process: Rantly { string },
    data: random_data_json
  }
end
