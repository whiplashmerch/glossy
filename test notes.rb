class Rando < Glossy::Base

  class << self

    def check(id) #return true if row is broken
      return 50 < Random.rand(100)
    end

    def fix(id)
      print "Sorry boss, no can do"
    end

  end
end


glossy = Glossy::Base.new(fixer: Rando)
ids = (0..99).to_a
glossy.check_all(ids)


# Future Tests

Glossy::Base.getColumns([{:name => "James"}]) == [:name]
Glossy::Base.getColumns({:name => "James"}) == [:name]
