# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      message = 'Method should be a symbol!'
      raise TypeError, message unless name.is_a? Symbol

      var_name = "@#{name}".to_sym
      history = name.to_s + '_history'
      var_history = "@#{history}".to_sym

      # setter and getter for attribute
      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |v|
        instance_variable_set(var_name, v)
        hist = instance_variable_get(var_history)
        if hist
          instance_variable_set(var_history, hist.push(v))
        else
          instance_variable_set(var_history, [v])
        end
      end

      define_method(history) { instance_variable_get(var_history) }
    end
  end
end
