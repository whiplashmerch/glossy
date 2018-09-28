$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'glossy'

require 'minitest/autorun'

class LessThan5 < Glossy::Base

  class << self

    def check(id) #return true if row is broken
      return id >= 5
    end

    def fix(id)
      print "Sorry boss, no can do. "
    end

  end
end