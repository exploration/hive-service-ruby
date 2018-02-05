# frozen_string_literal: true

require 'test_helper'

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
    atom = hive_service.post test_atom
    assert_kind_of HiveService::HiveAtom, atom
    assert_equal test_atom.application, atom.application

    delete_result = hive_service.delete atom
    assert_equal [], delete_result
  end

  def test_atom_receipt
    atom = hive_service.post test_atom
    updated_atom = hive_service.post_receipt atom
    assert_equal hive_service.application_name, updated_atom.receipts

    remove_test_atoms_from_hive
  end

  # rubocop:disable Metrics/AbcSize
  def test_get_unseen_atoms
    atom_a = hive_service.post test_atom
    atom_c = test_atom(process: 'test_process_3')

    search = hive_service.get_unseen_atoms(
      application: test_atom.application,
      receipts: hive_service.application_name
    )

    assert_equal 1, search.count
    assert compare_search_results search, atom_a
    refute compare_search_results search, atom_c

    remove_test_atoms_from_hive
  end
  # rubocop:enable Metrics/AbcSize

  private

  def compare_search_results(search_results, hive_atom)
    search_results.any? { |el| el.process == hive_atom.process }
  end

  def hive_service
    HiveService::HiveService.new(
      application_name: 'hive_service_ruby_test',
      hive_base_uri: 'http://127.0.0.1:4000',
      hive_token: ENV['HIVE_API_TOKEN']
    )
  end

  def remove_test_atoms_from_hive
    atoms = hive_service.get_unseen_atoms(
      application: test_atom.application,
      receipts: 'anything'
    )
    atoms&.each { |atom| hive_service.delete atom }
  end
end
