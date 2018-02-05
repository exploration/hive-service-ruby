# frozen_string_literal: true

require 'test_helper'

class HiveServiceTest < Minitest::Test
  def test_converting_hash_to_atom
    atom = test_atom
    assert atom.is_a? HiveService::HiveAtom
    assert_equal 'test_app', atom.application
    assert_equal 'test_context', atom.context
    assert_equal 'test_process', atom.process
    assert_equal '{"hello":"world"}', atom.data
    assert_equal 1, atom.id
  end

  def test_converting_hash_with_string_keys_to_atom
    application = 'string_key_test'
    atom = HiveService::HiveAtom.new('application' => application)
    assert_equal application, atom.application
  end

  def test_converting_json_to_atom
    atom = HiveService::HiveAtom.new(test_atom_json)
    assert atom.is_a? HiveService::HiveAtom
    assert_equal 'test_app', atom.application
    assert_equal 'test_context', atom.context
    assert_equal 'test_process', atom.process
    assert_equal '{"hello":"world"}', atom.data
    assert_equal 1, atom.id
  end

  def test_receipts_initialization
    receipts = 'test_receipt'
    assert_equal test_atom(receipts: receipts).receipts, receipts
  end

  def test_timestamps_initialization
    created_at = '2017-12-18T23:29:22.927451'
    updated_at = '2017-12-18T23:29:14.501361'
    atom = test_atom(created_at: created_at, updated_at: updated_at)
    assert_equal created_at, atom.created_at
    assert_equal updated_at, atom.updated_at
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def test_timestamp_parsing
    created_at = '2017-01-18T23:29:22.927451'
    updated_at = '2017-11-18T11:29:14.501361'
    atom = test_atom(created_at: created_at, updated_at: updated_at)
    cad = atom.created_at_datetime
    uad = atom.updated_at_datetime

    assert cad.is_a? DateTime
    assert_equal 1, cad.month
    assert_equal 23, cad.hour

    assert uad.is_a? DateTime
    assert_equal 11, uad.month
    assert_equal 11, uad.hour
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def test_getting_the_triplet
    expected_triplet = %w[test_app test_context test_process]
    assert_equal expected_triplet, test_atom.triplet
  end

  def test_getting_data_as_a_hash
    expected_hash = { 'hello' => 'world' }
    assert_equal expected_hash, test_atom.data_hash
  end

  def test_empty_data_hash_returns_empty_object
    atom = HiveService::HiveAtom.new(data: nil)
    assert_equal '{}', atom.data
    assert_equal({}, atom.data_hash)
  end

  def test_converts_to_hash
    expected_hash = {
      'id' => 1, 'application' => 'test_app',
      'context' => 'test_context', 'process' => 'test_process',
      'data' => '{"hello":"world"}', 'receipts' => nil,
      'created_at' => nil, 'updated_at' => nil
    }
    assert_equal expected_hash, test_atom.to_h
  end

  def test_converts_to_json
    expected_json = '{"id":1,"application":"test_app","context":' \
                    '"test_context","process":"test_process","data":' \
                    '"{\"hello\":\"world\"}","receipts":null,"created_at"' \
                    ':null,"updated_at":null}'
    assert_equal expected_json, test_atom.to_json
  end

  def test_to_s_returns_json
    assert_equal test_atom.to_s, test_atom.to_json
  end

  def test_atom_parsing_random_values
    state = property_of do
      hash = random_atom_hash
      HiveService::HiveAtom.new hash
    end

    state.check(100) do |atom|
      assert_kind_of HiveService::HiveAtom,
                     atom,
                     'HiveAtom parse didn\'t return a valid HIVE Atom.'

      assert_kind_of Hash, atom.data_hash
    end
  end
end
