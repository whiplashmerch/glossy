require 'test_helper'

class GlossyTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Glossy::VERSION
  end

  def test_instance_can_check_all
    glossy = Glossy::Base.new(fixer: LessThan5)
    ids = (0..9).to_a
    glossy.check_all(ids)
    assert glossy.results == [{0=>false}, {1=>false}, {2=>false}, {3=>false}, {4=>false}, {5=>true}, {6=>true}, {7=>true}, {8=>true}, {9=>true}]
    assert glossy.started_at.is_a? Time
    assert glossy.completed_at.is_a? Time
    assert glossy.failed_ids == [5, 6, 7, 8, 9]
    assert glossy.passed_ids == [0, 1, 2, 3, 4]
    assert_nil glossy.fix_all
  end

  def test_instance_can_check
    glossy = Glossy::Base.new(fixer: LessThan5)
    glossy.check(4)
  end

  def test_instance_can_check
    glossy = Glossy::Base.new(fixer: LessThan5)
    glossy.fix(4)
  end


end
