require "active_record/operators"
module AROperators
  def where(args, *opts)
    include_operators_on super
  end

  def scoped(*args)
    include_operators_on super(*args)
  end

  def include_operators_on(relation)
    metaclass = class << relation; self; end
    metaclass.send :include, ActiveRecord::Operators
    return relation
  end
  private :include_operators_on
end
