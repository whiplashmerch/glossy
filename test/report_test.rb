require 'test_helper'

class ReportTest < Minitest::Test

  def test_tableize
    artists = [{name: "Meg White", band: "White Stripes"}, {name: "Robert Plant", band: "Led Zepplin"}, {name: "Robert Smith", band: "The Cure"}]
    out = Glossy::Base.tableize(artists, column_width: 20)
    assert out == "name                band                \nMeg White           White Stripes       \nRobert Plant        Led Zepplin         \nRobert Smith        The Cure            \n"
  end

  def test_format
    assert Glossy::Base.format("yo", format: :tab ) == "yo\t"
    assert Glossy::Base.format("yo", format: 'tab' ) == "yo\t"
    assert Glossy::Base.format("yo", column_width: 20 ) == "yo                  "
    assert Glossy::Base.format("yo") == "yo             "
  end

  def test_delimit
    assert Glossy::Base.delimit("yeah", ",") == "yeah,"

    original_string = "yup"
    assert Glossy::Base.delimit(original_string, ",") == 'yup,'
    assert original_string == "yup"
  end

  def test_get_columns_accepts_array
    assert Glossy::Base.getColumns([{:name => "Malcolm"}]) == [:name]
  end

  def test_get_columns_accept_hash
    assert Glossy::Base.getColumns({:name => "Alana"}) == [:name]
  end


end
