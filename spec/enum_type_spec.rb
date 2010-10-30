require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module SpecSupport
  class EnumTypeTester
    include ActiveModel::Validations
    extend EnumType
    
    def self.set_field(field)
      @field = field
      reset_callbacks :validate
      _validators.clear
      enum_type @field
    end

    def self.field() @field end

    def read_attribute(_)
      instance_variable_get :"@#{self.class.field}"
    end

    def write_attribute(_, value)
      instance_variable_set :"@#{self.class.field}", value
    end

    def set(value)
      instance_variable_set :"@#{self.class.field}", value
    end

    def get
      instance_variable_get :"@#{self.class.field}"
    end
  end
end

describe EnumType do
  before :each do
    @field = Factory.next(:enum_field)
    SpecSupport::EnumTypeTester.set_field(@field)
    @model = SpecSupport::EnumTypeTester.new
  end

  describe "#enum_type" do
    context "getter" do
      it "should return a symbol" do
        @model.set 'string'
        @model.send(@field).should eql(:string)
      end

      it "should return nil if the value is nil" do
        @model.set nil
        @model.send(@field).should be_nil
      end
    end

    context "setter" do
      it "should typecast the value to a string" do
        @model.send :"#{@field}=", :string
        @model.get.should eql('string')
      end

      it "should leave nil as nil" do
        @model.send :"#{@field}=", nil
        @model.get.should be_nil
      end
    end

    it "should validate inclusion if :values option is given" do
      SpecSupport::EnumTypeTester.enum_type @field, values: [ :a, :b ]
      @model.send :"#{@field}=", :a
      @model.get.should eql('a')
      @model.should be_valid
      @model.send :"#{@field}=", :c
      @model.should_not be_valid
    end

    it "should not validate presence if :allow_nil is true" do
      pending "Doesn't work"
      SpecSupport::EnumTypeTester.enum_type @field, allow_nil: true
      @model.send :"#{@field}=", nil
      @model.should be_valid
    end

    it "should validate presence if :allow_nil is not given" do
      SpecSupport::EnumTypeTester.enum_type @field
      @model.send :"#{@field}=", nil
      @model.should_not be_valid
    end

    it "should validate presence if :allow_nil is false" do
      SpecSupport::EnumTypeTester.enum_type @field, allow_nil: false
      @model.send :"#{@field}=", nil
      @model.should_not be_valid
    end
  end
end
