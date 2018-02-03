require "test_helper"

class HiveServiceTest < Minitest::Test
  SETUP = begin
    if ENV['HIVE_API_TOKEN'].nil?
      puts 'You need to set the HIVE_API_TOKEN environment variable.'
    end
    puts 'Make sure to start your HIVE development server on localhost:4000'
  end

  def test_that_it_has_a_version_number
    refute_nil ::HiveService::VERSION
  end

  def test_atom_post_delete
    a = hive_service.post atom
    assert_kind_of HiveService::HiveAtom, a
    assert_equal atom.application, a.application

    delete_result = hive_service.delete a 
    assert_equal [], delete_result
  end

  def test_atom_receipt
    a = hive_service.post atom
    updated_a = hive_service.post_receipt a
    assert_equal hive_service.application_name, updated_a.receipts

    remove_test_atoms_from_hive()
  end

  def test_get_unseen_atoms
    a = hive_service.post atom
    b = hive_service.post atom(process: 'test_process_2')
    c = atom(process: 'test_process_3')

    search = hive_service.get_unseen_atoms(
      application: atom.application,
      receipts: hive_service.application_name
    )

    assert_equal 2, search.count
    assert search.find {|el| el.process == a.process}
    assert search.find {|el| el.process == b.process}
    refute search.find {|el| el.process == c.process}

    remove_test_atoms_from_hive()
  end

  private

  def hive_service
    HiveService::HiveService.new(
      application_name: 'hive_service_ruby_test',
      hive_base_uri: 'http://127.0.0.1:4000',
      hive_token: ENV['HIVE_API_TOKEN']
    )
  end

  def remove_test_atoms_from_hive
    atoms = hive_service.get_unseen_atoms(
      application: atom.application,
      receipts: 'anything'
    )
    atoms.each {|a| hive_service.delete a} unless atoms.nil?
  end
end
