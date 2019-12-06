require 'rspec'
require_relative '../accessors.rb'

describe 'Accessors' do
  before(:all) do
    class TestClass
      extend Accessors
    end
    @test_object = TestClass.new
  end
  it 'should create reader for name and name_history' do
    expect(@test_object.instance_variables).to eq([])
    TestClass.send(:attr_accessor_with_history, :smth, :test)
    @test_object.smth = 1
    expect(@test_object.instance_variables).to eq(%i[@smth @smth_history])
    @test_object.test = '1234'
    methods = %i[@smth @smth_history @test @test_history]
    expect(@test_object.instance_variables).to eq(methods)
  end
  it 'should correctly track variable history' do
    expect(@test_object.test_history).to eq(['1234'])
    @test_object.test = 1234
    expect(@test_object.test_history).to eq(['1234', 1234])
    @test_object.test += 12
    @test_object.test = nil
    expect(@test_object.test_history).to eq(['1234', 1234, 1246, nil])
  end
  it 'should create variables with strong typing' do
    TestClass.send(:strong_attr_accessor, :strong, Integer)
    @test_object.strong = 10
    expect(@test_object.strong).to eq(10)
    expect { @test_object.strong = '1' }.to raise_error(TypeError)
    expect { @test_object.strong = [1] }.to raise_error(TypeError)
  end
end
