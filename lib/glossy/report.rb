module Glossy
  class Report << Base

    def summarize(column_width=15)
      headers = ["Tested", "Passed", "Failed", "% Failure"]
      out = ""
      headers.map { |header| out << "#{toWidth(header, column_width)}" }
      out << "\n"
      rows = []
      rows << results.size # Tested
      rows << results.count{ |r| r.values[0] == false } # Passed
      rows << results.size - rows[1] # Failed
      rows << ((begin rows[2].to_f / rows[0].to_f rescue 0.0 end) * 100).round(3)
      rows.map { |row| out << "#{toWidth(row.to_s, column_width)}" }
      # out << "\n Completed in #{self.time_in_seconds}"
      # TODO Benchmark
      print out
    end

    def toWidth(str, width)
      while str.size < width do
        str << " "
      end
      return str
    end
  end
end