$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hive_service'
require 'minitest/autorun'

def atom(options = {})
  HiveService::HiveAtom.new(atom_hash.merge(options))
end

def atom_hash
  {
    application: 'test_app',
    context: 'test_context',
    process: 'test_process',
    data: %({"hello":"world"}),
    id: 1
  }
end

def atom_json
  atom_hash.to_json
end
