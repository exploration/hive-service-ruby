require "test_helper"

class HiveServiceTest < Minitest::Test
  SETUP = begin
    if ENV['HIVE_API_TOKEN'].nil?
      puts 'You need to set the HIVE_API_TOKEN environment variable.'
    end
    puts 'Make sure to start your HIVE development server!'
  end

  def test_that_it_has_a_version_number
    refute_nil ::HiveService::VERSION
  end

  def test_atom_post_update_delete
    a = hive_service.post atom
    assert_kind_of HiveService::HiveAtom, a
    assert_equal atom.application, a.application

    delete_result = hive_service.delete a 
    assert_equal [], delete_result
  end

  private

  def hive_service
    HiveService::HiveService.new(
      application_name: 'hive_service_ruby_test',
      hive_base_uri: 'http://127.0.0.1:4000',
      hive_token: ENV['HIVE_API_TOKEN']
    )
  end
end
