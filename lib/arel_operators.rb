require "arel_operators/operators"
require 'arel_operators/finder'
module ArelOperators
  def where(*args, &b)
    if b
      arel = arel_from_block &b
      result = where(arel)
      return result if args.empty?
      return result.where(*args)
    end
    include_operators_on super
  end

  def arel_from_block(&b)
    if b.arity == -1 || b.arity == 0
      ArelOperators::Finder.new(arel_table).instance_eval(&b).arel
    else
      b.call(ArelOperators::Finder.new(arel_table)).arel
    end
  end
  private :arel_from_block

  def scoped(*args)
    include_operators_on super(*args)
  end

  def include_operators_on(relation)
    metaclass = class << relation; self; end
    metaclass.send :include, ArelOperators::Operators
    return relation
  end
  private :include_operators_on
end
