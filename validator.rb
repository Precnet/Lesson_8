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
      @validations ||= {}
      @validations[validation_type] ||= []
      @validations[validation_type].push([attribute, params])
    end

    private

    def check_validation_type(type)
      message = "Validation type should be 'presence', 'format' or 'type'!"
      raise RailwayError, message unless %w[presence format type].include? type.to_s
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
      self.class.validations.each_key do |type|
        self.class.validations[type].each do |params|
          command = ('validate_' + type.to_s).to_sym
          send(command, *params)
        end
      end
    end

    private

    def validate_presence(attribute)
      message = "There is no attribute #{attribute} in class '#{self.class}'!"
      has_attribute = self.class.instance_variables.include? attribute
      raise RailwayError, message unless has_attribute
    end

    def validate_format(attribute, format)
      message = "'#{attribute}' should be of format '#{format[0]}'"
      raise RailwayError, message unless attribute =~ format[0]
    end

    def validate_type(attribute, type)
      message = "'#{attribute}' should be '#{type[0]}'!"
      message += "\nGot: #{attribute.class}, #{attribute.inspect}"
      raise RailwayError, message unless attribute.is_a?(type[0])
    end
  end
end
