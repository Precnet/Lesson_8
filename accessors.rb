# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      check_attr_name_is_symbol(name)

      var_name = "@#{name}".to_sym
      history = name.to_s + '_history'
      var_history = "@#{history}".to_sym

      # setter and getter for attribute
      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        hist = instance_variable_get(var_history)
        if hist
          instance_variable_set(var_history, hist.push(value))
        else
          instance_variable_set(var_history, [value])
        end
      end

      define_method(history) { instance_variable_get(var_history) }
    end
  end

  def strong_attr_accessor(attr, attr_class)
    check_attr_name_is_symbol(attr)

    attr_sym = "@#{attr}".to_sym
    define_method(attr) { instance_variable_get(attr_sym) }
    define_method("#{attr}=".to_sym) do |value|
      message = "This variable should be a #{attr_class}!"
      raise TypeError, message unless value.is_a? attr_class

      instance_variable_set(attr_sym, value)
    end
  end

  private

  def check_attr_name_is_symbol(attr)
    message = 'Method should be a symbol!'
    raise TypeError, message unless attr.is_a? Symbol
  end
end
