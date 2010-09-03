module ActiveRecord
  module Operators
    def |(other)
      build_arel_predicate(Arel::Predicates::Or, self, other)
    end

    def &(other)
      build_arel_predicate(Arel::Predicates::And, self, other)
    end

    def -(other)
      self & (-other)
    end

    def -@
      build_arel_predicate(Arel::Predicates::Not, self)
    end

    def where(obj, *args)
      return super unless obj.respond_to?(:build_where)
      relation = obj.select(:id)
      self & clone.tap do |c|
        cond = build_where(Arel::Predicates::In.new(relation.primary_key, relation.arel))
        c.where_values = Array.wrap(cond)
      end
    end

    private
    def build_arel_predicate(predicate, *args)
      clone.tap do |c|
        condition = build_predicate(predicate, *args)
        cond = build_where(condition)
        c.where_values = Array.wrap(cond)
        possible_joins = args.select { |x| x.object_id != object_id && x.respond_to?(:joins_values) }
        c.joins_values += possible_joins.collect { |x| x.joins_values }
      end
    end

    def build_predicate(predicate, *relations)
      values = relations.collect do |relation|
        value = relation.is_a?(ActiveRecord::Relation) ? relation.where_values : relation
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
