# frozen_string_literal: true

require_relative 'railway_error.rb'

module Validator
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validations
      @validations
    end

    def validate(attribute, validation_type, *params)
      check_validation_type(validation_type)
      check_attribute(attribute)
      @validations ||= {}
      @validations[validation_type] ||= []
      @validations[validation_type].push([attribute, params])
    end

    private

    def check_validation_type(type)
      message = "Validation type should be 'presence', 'format' or 'type'!"
      unless %w[presence format type positive].include? type.to_s
        raise RailwayError, message
      end
    end

    def check_attribute(attribute)
      message = 'Attribute should be a symbol!'
      raise RailwayError, message unless attribute.is_a?(Symbol)
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RailwayError => e
      puts e.message
      false
    end

    def validate!
      puts self.class.validations
      self.class.validations.each_key do |type|
        self.class.validations[type].each do |params|
          command = ('validate_' + type.to_s).to_sym
          send(command, *params)
        end
      end
    end

    private

    def validate_presence(attribute, *params)
      message = "There is no attribute #{attribute} in class '#{self.class}'!"
      has_attribute = instance_variable_get("@#{attribute}".to_sym)
      raise RailwayError, message unless has_attribute
    end

    def validate_format(attribute, format)
      message = "'#{attribute}' should be of format '#{format[0]}'"
      value = instance_variable_get("@#{attribute}".to_sym)
      raise RailwayError, message unless value =~ format[0]
    end

    def validate_type(attribute, type)
      message = "'#{attribute}' should be '#{type[0]}'!"
      value = instance_variable_get("@#{attribute}".to_sym)
      raise RailwayError, message unless value.is_a?(type[0])
    end

    def validate_positive(attribute, *params)
      validate_type(attribute, [Integer])
      message = "'#{attribute}' should be positive!"
      value = instance_variable_get("@#{attribute}".to_sym)
      raise RailwayError, message unless value >= 0
    end
  end
end
