require "arel_operators/finder/comparators"
module ArelOperators
  class Finder
    attr_reader :table, :arel

    def initialize(arel_table, operation=nil)
      @table = arel_table
      @arel = operation
      @table.columns.each { |a| define_attribute_method a }
    end

    def define_attribute_method(arel_attribute)
      singleton_class.send :define_method, arel_attribute.name do
        ArelOperators::Finder::Comparators.new(self, arel_attribute)
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
      Finder.new(table, Arel::Nodes::Not.new(arel))
    end

    undef_method :==
  end
end

__END__
