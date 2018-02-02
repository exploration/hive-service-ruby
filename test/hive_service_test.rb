require "test_helper"

class HiveServiceTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::HiveService::VERSION
  end
end
