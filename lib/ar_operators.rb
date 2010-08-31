require "active_record/operators"
module AROperators
  def where(args, *opts)
    relation = super
    metaclass = class << relation; self; end
    metaclass.send :include, ActiveRecord::Operators
    return relation
  end
end
