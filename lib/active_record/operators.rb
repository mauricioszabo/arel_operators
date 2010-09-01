module ActiveRecord
  module Operators
    def |(other)
      build_arel_conditions build_predicate(Arel::Predicates::Or, self, other)
    end

    def &(other)
      build_arel_conditions build_predicate(Arel::Predicates::And, self, other)
    end

    def -(other)
      self & (-other)
    end

    def -@
      build_arel_conditions build_predicate(Arel::Predicates::Not, self)
    end

    def where(obj, *args)
      if obj.respond_to?(:build_where)
        relation = obj.select(:id)
        self & build_arel_conditions(Arel::Predicates::In.new(relation.primary_key, relation.arel))
      else
        super
      end
    end

    private
    def build_arel_conditions(condition)
      clone.tap do |c|
        cond = build_where(condition)
        c.where_values = Array.wrap(cond)
      end
    end

    def build_predicate(predicate, *relations)
      values = relations.collect do |relation|
        value = relation.where_values
        wrap_predicate_value(value)
      end
      predicate.new(*values)
    end

    def wrap_predicate_value(value)
      value.collect do |v|
        if v.is_a?(String)
          Arel::SqlLiteral.new(v)
        else
          v
        end
      end
    end
  end
end
