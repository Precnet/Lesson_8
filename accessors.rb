# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      message = 'Method should be a symbol!'
      raise TypeError, message unless name.is_a? Symbol

      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |v|
        instance_variable_set(var_name, v)
        instance_variable_set(var_name, v)
      end

      history = name.to_s + '_history'
      var_history = "@#{name}_history".to_sym



      # define_method(history_name) { instance_variable_get(history_name) }
      # setter
      # define_method("#{name}=") do |v|
      #   instance_variable_set("@#{name}", v)
      # end
    end
  end
end
