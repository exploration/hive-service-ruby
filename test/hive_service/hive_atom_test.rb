require 'test_helper'

class HiveServiceTest < Minitest::Test
  def test_converting_hash_to_atom
    a = atom
    assert a.is_a? HiveService::HiveAtom
    assert_equal 'test_app', a.application
    assert_equal 'test_context', a.context
    assert_equal 'test_process', a.process
    assert_equal '{"hello":"world"}', a.data
    assert_equal 1, a.id
  end

  def test_converting_hash_with_string_keys_to_atom
    application = 'string_key_test'
    a = HiveService::HiveAtom.new('application' => application)
    assert_equal application, a.application
  end

  def test_converting_json_to_atom
    a = HiveService::HiveAtom.new(atom_json)
    assert a.is_a? HiveService::HiveAtom
    assert_equal 'test_app', a.application
    assert_equal 'test_context', a.context
    assert_equal 'test_process', a.process
    assert_equal '{"hello":"world"}', a.data
    assert_equal 1, a.id
  end

  def test_receipts_initialization
    receipts = 'test_receipt'
    assert_equal atom(receipts: receipts).receipts, receipts 
  end

  def test_timestamps_initialization
    created_at = '2017-12-18T23:29:22.927451'
    updated_at = '2017-12-18T23:29:14.501361'
    a = atom(created_at: created_at, updated_at: updated_at)
    assert_equal created_at, a.created_at
    assert_equal updated_at, a.updated_at
  end

  def test_timestamp_parsing
    created_at = '2017-01-18T23:29:22.927451'
    updated_at = '2017-11-18T11:29:14.501361'
    a = atom(created_at: created_at, updated_at: updated_at)
    cad = a.created_at_datetime
    uad = a.updated_at_datetime

    assert cad.is_a? DateTime
    assert_equal 1, cad.month
    assert_equal 23, cad.hour

    assert uad.is_a? DateTime
    assert_equal 11, uad.month
    assert_equal 11, uad.hour
  end

  def test_getting_the_triplet
    expected_triplet = ['test_app', 'test_context', 'test_process']
    assert_equal expected_triplet, atom.triplet
  end

  def test_getting_data_as_a_hash
    expected_hash = {'hello' => 'world'}
    assert_equal expected_hash, atom.data_hash
  end

  def test_empty_data_hash_returns_empty_object
    a = HiveService::HiveAtom.new(data: nil)
    assert_equal '{}', a.data
    assert_equal({}, a.data_hash)
  end

  def test_converts_to_hash
    expected_hash = {"id"=>1, "application"=>"test_app", "context"=>"test_context", "process"=>"test_process", "data"=>"{\"hello\":\"world\"}", "receipts"=>nil, "created_at"=>nil, "updated_at"=>nil}
    assert_equal expected_hash, atom.to_h
  end

  def test_converts_to_json
    expected_json = "{\"id\":1,\"application\":\"test_app\",\"context\":\"test_context\",\"process\":\"test_process\",\"data\":\"{\\\"hello\\\":\\\"world\\\"}\",\"receipts\":null,\"created_at\":null,\"updated_at\":null}"
    assert_equal expected_json, atom.to_json
  end

  def test_to_s_returns_json
    assert_equal atom.to_s, atom.to_json
  end
end
