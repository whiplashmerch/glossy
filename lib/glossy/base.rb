module Glossy

  class Base

    attr_accessor :results, :fixer, :details

    def initialize(fixer: nil)
      self.fixer = fixer
      self.details = Array.new
      disable_active_record_logging
      print_logo
      # TODO: write logs to a file and allow it be dumped with gloss.logs
    end





################################################################
################################################################




################################################################
################################################################




    # If no failed_ids param is sent, fallback to the saved results
    def fix_all()
      print "No failures to fix" unless results.size > 0
      self.started_at = Time.now
      failed_ids.collect{ |id| print "Attempting to fix ID #{id}..."; fix(id); print "Done\n" }
      retest_failures
    end

    def retest_failures()
      check_all(failed_ids)
    end

    def check_all(ids)
      return unless ids.is_a?(Array)
      print "Beginning check of #{ids.size}\n"
      self.results = []
      ids.each_with_index do |id, i|
        print "Checking ID #{id}...\n"
        results << {id => self.fixer.check(id) }
        self.completed_at = Time.now if ids.size == i
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

    def retest_failures
      self.check_all(failed_ids)
    end

    def failed_ids
      results.collect{ |r| r.keys[0] if r.values[0] != false }.compact.uniq
    end

    def passed_ids
      results.collect{ |r| r.keys[0] if r.values[0] == false }.compact.uniq
    end

  end

end