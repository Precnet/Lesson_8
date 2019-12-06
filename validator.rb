require_relative 'railway_error.rb'

module Validator
  def valid?
    validate!
    true
  rescue RailwayError
    false
  end

  def validate(attribute, validation_type, *params)

  end

  private

  def validate_presence(attribute)

  end

  def validate_format(attribute, format)

  end

  def validate_type(attribute, type)

  end
end
