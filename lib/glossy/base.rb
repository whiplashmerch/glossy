module Glossy
  require 'glossy/report'

  class Base
    attr_accessor :results, :fixer, :details, :started_at, :completed_at

    def initialize(fixer: nil)
      self.fixer = fixer
      self.details = []
      disable_active_record_logging
      print_logo
    end

    def fix_all
      print 'No failures to fix' if results.empty?
      self.started_at = Time.now
      failed_ids.collect { |id| print "Attempting to fix ID #{id}..."; fix(id); print "Done\n" }
      retest_failures
    end

    def retest_failures
      check_all(failed_ids)
    end

    def check_all(ids)
      return unless ids.is_a?(Array)
      print "Beginning check of #{ids.size}\n"
      self.started_at = Time.now
      self.results = []
      ids.each_with_index do |id, i|
        print "Checking ID #{id}...\n"
        results << { id => fixer.check(id) }
        self.completed_at = Time.now if ids.size == (i + 1)
      end
      summarize
    end

    def print_logo
      print "                                 ________                                              \n                                / ____/ /___  ____________  __   _                     \n                               / / __/ / __ \\/ ___/ ___/ / / /  (_)                    \n                              / /_/ / / /_/ (__  )__  ) /_/ /  _                       \n                              \\____/_/\\____/____/____/\\__, /  (_)                      \n                                                     /____/                            "
      print "\n\n\n"
      print "       _______         _       ____          __ _         ____             __                                 \n      / ____(_)  __   | |     / / /_  ____ _/ /_ )____   / __ )_________  / /_____  ____                      \n     / /_  / / |/_/   | | /| / / __ \\/ __ `/ __// ___/  / __  / ___/ __ \\/ //_/ _ \\/ __ \\                     \n    / __/ / />  <     | |/ |/ / / / / /_/ / /_  (__  )  / /_/ / /  / /_/ / ,< /  __/ / / /                     \n   /_/   /_/_/|_|     |__/|__/_/ /_/\\__,_/\\__/ /____/  /_____/_/   \\____/_/|_|\\___/_/ /_/                      \n                                                                                                              "
    end

    def disable_active_record_logging
      ActiveRecord::Base.logger = nil if defined? ActiveRecord
    end

    def enable_active_record_logging
      ActiveRecord::Base.logger = Logger.new(STDOUT) if defined? ActiveRecord
    end

    def failed_ids
      results.collect { |r| r.keys[0] if r.values[0] }.compact.uniq
    end

    def passed_ids
      results.collect { |r| r.keys[0] unless r.values[0] }.compact.uniq
    end
  end
end
