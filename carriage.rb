# frozen_string_literal: true

require_relative 'validator.rb'
require_relative 'railway_error.rb'

# Carriage
class Carriage
  include Manufacturer
  include Validator

  LENGTH = 5
  BASE_36 = 36
  CARRIAGE_TYPE = ''

  attr_reader :number, :type
  @@carriages = []

  validate :number, :presence
  validate :number, :type, String
  validate :number, :length, 3, 20

  def self.carriages
    @@carriages
  end

  def initialize(carriage_number)
    @number = carriage_number
    validate!
    @@carriages.push(self)
  end

  protected

  # this is a method for creating default name for carriage it should not
  # be used outside of object constructor
  def generate_number(number_length)
    CARRIAGE_TYPE + '_' + rand(BASE_36**number_length).to_s(BASE_36)
  end
end
