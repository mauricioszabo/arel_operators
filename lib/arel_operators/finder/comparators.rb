module ArelOperators
  class Finder
    class Comparators
      def initialize(finder, field)
        @finder = finder
        @field = finder.table[field]
      end

      def ==(other)
        create_finder @field.eq(other)
      end

      if RUBY_VERSION >= '1.9.0'
        eval '
          def !=(other)
            create_finder @field.not_eq(other)
          end
        '
      end

      def >(other)
        create_finder @field.gt(other)
      end

      def >=(other)
        create_finder @field.gteq(other)
      end

      def <(other)
        create_finder @field.lt(other)
      end

      def <=(other)
        create_finder @field.lteq(other)
      end

      private
      def create_finder(arel)
        ArelOperators::Finder.new(@finder.table, arel)
      end
    end
  end
end
