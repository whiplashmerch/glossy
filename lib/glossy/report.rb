module Glossy

  class Base 

    def summarize
      out = {}
      out['Tested'] = results.size
      out['Passed'] = results.count{ |r| r.values[0] == false }
      out['Failed'] = results.size - out['Passed']
      out['Failure Rate'] = ((begin out['Failed'].to_f / out['Tested'].to_f rescue 0.0 end) * 100).round(3)
      print Glossy::Base.tableize(out)
    end

    class << self

      def tableize(raw, options={})
        columns = getColumns(raw, options)
        out = ""
        columns.map { |column| out << "#{format(column.to_s, options)}"}
        out << "\n"
        getRows(raw, options).each do |row|
            columns.each do |column|
                out << format(row[column].to_s, options)
            end
           out << "\n"
        end
        return out
      end

      def getRows(raw, options={})
        return [raw] if raw.is_a? Hash
        return raw if raw.is_a? Array
      end

      def getColumns(raw, options={})
        return options[:columns] if options[:columns]
        return raw.keys.uniq.flatten if raw.is_a? Hash
        content_type = raw.collect{ |r| r.class }.uniq
        return raw.map{ |r| r.keys}.uniq.flatten if content_type.size == 1 && content_type.first == Hash
        return nil
      end

      def toWidth(str, width, fill=' ')
        out = str.dup
        while out.size < width do
          out << fill
        end
        return out
      end

      def format(str, options={})
        return delimit(str.to_s, "\t") if ['tab', :tab].include? options[:format]
        column_width = options[:column_width] || 15
        return toWidth(str.to_s, column_width)
      end

      def delimit(str, delimiter)
          str.to_s << delimiter.to_s
          return str
      end
    end

  end

end