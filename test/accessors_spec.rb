require 'rspec'
require_relative '../accessors.rb'

describe 'Accessors' do
  before(:all) do
    class TestClass
      extend Accessors
      attr_accessor_with_history :test
    end
  end
  it 'should create reader for name and name_history' do
    test_object = TestClass.new
    test_object.test = 1
    puts
    puts test_object.instance_variables
    puts test.
    puts
    # print(TestClass.instance_variables)
  end
end
