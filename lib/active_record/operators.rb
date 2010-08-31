module ActiveRecord
  module Operators
    def +(other)
      clone.tap do |c|
        cond = build_where(Arel::Predicates::Or.new(where_values, other.where_values))
        c.where_values = Array.wrap(cond)
      end
    end

    def -(other)
      clone.tap do |c|
        cond = build_where(Arel::Predicates::And.new(where_values, Arel::Predicates::Not.new(other.where_values)))
        c.where_values = Array.wrap(cond)
      end
    end

    def -@
      clone.tap do |c|
        cond = build_where(Arel::Predicates::Not.new(where_values))
        c.where_values = Array.wrap(cond)
      end
    end
  end
end
