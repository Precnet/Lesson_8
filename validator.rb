require_relative 'railway_error.rb'

module Validator
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(attribute, validation_type, *params)
      check_validation_type(validation_type)
    end

    private

    def check_validation_type(type)
      message = "Validation type should be 'presence', 'format' or 'type'!"
      raise TypeError, message unless %w[presence format type].include? type
    end

    def validate_presence(attribute)
    end

    def validate_format(attribute, format)
    end

    def validate_type(attribute, type)
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RailwayError
      false
    end
  end
end
