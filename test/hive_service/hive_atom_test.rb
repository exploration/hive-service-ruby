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
    application = "string_key_test"
    a = HiveService::HiveAtom.new("application" => application)
    assert_equal application, a.application
  end

  def test_getting_the_triplet
    expected_triplet = ["test_app", "test_context", "test_process"]
    assert_equal expected_triplet, atom.triplet
  end

  def test_getting_data_as_a_hash
    expected_hash = {"hello" => "world"}
    assert_equal expected_hash, atom.data_hash
  end

  def test_empty_data_hash_returns_empty_object
    a = HiveService::HiveAtom.new(data: nil)
    assert_equal "{}", a.data
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

  private

  def atom(options = {})
    HiveService::HiveAtom.new(atom_hash.merge(options))
  end

  def atom_hash
    {
      application: "test_app",
      context: "test_context",
      process: "test_process",
      data: %({"hello":"world"}),
      id: 1
    }
  end
  
  def atom_json
    atom_hash.to_json
  end
end
