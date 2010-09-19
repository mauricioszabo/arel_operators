require "arel_operators/finder/comparators"
module ArelOperators
  class Finder
    attr_reader :table, :arel

    def initialize(arel_table, operation=nil)
      @table = arel_table
      @arel = operation
      @table.attributes.each { |a| define_attribute_method a.name }
    end

    def define_attribute_method(attribute)
      singleton_class.send :define_method, attribute do
        ArelOperators::Finder::Comparators.new(self, @table[attribute])
      end
    end
    private :define_attribute_method

    def |(other)
      other = other.arel if other.respond_to?(:arel)
      Finder.new(table, arel.or(other))
    end

    def &(other)
      other = other.arel if other.respond_to?(:arel)
      Finder.new(table, arel.and(other))
    end

    if RUBY_VERSION >= '1.9.0'
      eval '
        def !@
          -self
        end
      '
    end

    def -@
      Finder.new(table, Arel::Predicates::Not.new(arel))
    end

    undef_method :==
  end
end

__END__
