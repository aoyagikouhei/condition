module Condition
  module Storage
    class RailsDb
      LOG_NAME = 'SQL'

      def initialize(db: nil)
        @conn = db.nil? ? ActiveRecord::Base.connection : db
      end

      def commit
        @conn.commit_db_transaction
      end

      def all(param_item)
        sql = "SELECT * FROM #{param_item.name}"
        res = exec(sql)
        #res.to_hash
        convert_keys(res)
      end

      def delete(param_item)
        sql = "DELETE FROM #{param_item.name}"
        exec sql
      end

      def insert(param_item, default)
        default_item = default.item(param_item.name) if default
        prms = default_item ? default_item.params.merge(param_item.params) : param_item.params
        i1 = ''
        prms.each_pair do |k, v|
          if i1 != ''
            i1 = i1 + ', '
          end
          i1 = i1 + k.to_s
        end
        param_item.values.each do |it|
          prms = default_item ? default_item.value.merge(it) : it
          ary = []
          prms.each_pair do |k, v|
            ary << quote_value(v)
          end
          i2 = ary.join(',')
          sql = "INSERT INTO #{param_item.name.to_s} (#{i1}) VALUES (#{i2})"
          exec sql
        end
      end

      def exec_after(param_item)
        param_item.options.each do |key|
          exec key
        end
      end

      private
        def quote_value(val)
          return 'NULL' if val.nil?
          v = val.gsub(/'/, "''")
          "'#{v}'"
        end

        def exec(sql)
          @conn.exec_query(sql, LOG_NAME, [])
        end

        def convert_keys(ary)
          res = []
          ary.each do |row|
            res.push(row.deep_symbolize_keys)
          end
          res
        end
    end
  end
end
