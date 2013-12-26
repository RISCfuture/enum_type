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
  describe "#enum_type" do
    context "[getter]" do
      it "should return a symbol" do
        Model.connection.execute "INSERT INTO models (state) VALUES ('completed')"
        expect(Model.last.state).to eql(:completed)
      end

      it "should return nil if the value is nil" do
        Model.connection.execute "INSERT INTO models (state) VALUES (NULL)"
        expect(Model.last.state).to be_nil
      end
    end

    context "[setter]" do
      it "should typecast the value to a string" do
        m       = Model.new
        m.state = :failed
        expect(m.state).to eql(:failed)
        m.save!
        expect(m.reload.state).to eql(:failed)
        expect(m.state_before_type_cast).to eql('failed')
      end

      it "should leave nil as nil" do
        m       = Model.new
        m.state = nil
        expect(m.state).to eql(nil)
        m.save!
        expect(m.reload.state).to be_nil
      end
    end

    context "[validations]" do
      before :each do
        @field = FactoryGirl.generate(:enum_field)
        SpecSupport::EnumTypeTester.set_field(@field)
        @model = SpecSupport::EnumTypeTester.new
      end
      
      it "should validate inclusion if :values option is given" do
        SpecSupport::EnumTypeTester.enum_type @field, values: [ :a, :b ]
        @model.send :"#{@field}=", :a
        expect(@model.get).to eql('a')
        expect(@model).to be_valid
        @model.send :"#{@field}=", :c
        expect(@model).not_to be_valid
      end

      it "should not validate presence if :allow_nil is true" do
        pending "Doesn't work"
        SpecSupport::EnumTypeTester.enum_type @field, allow_nil: true
        @model.send :"#{@field}=", nil
        expect(@model).to be_valid
      end
      
      it "should validate presence if :allow_nil is not given" do
        SpecSupport::EnumTypeTester.enum_type @field
        @model.send :"#{@field}=", nil
        expect(@model).not_to be_valid
      end
      
      it "should validate presence if :allow_nil is false" do
        SpecSupport::EnumTypeTester.enum_type @field, allow_nil: false
        @model.send :"#{@field}=", nil
        expect(@model).not_to be_valid
      end
    end
    
    it "should determine the correct column default" do
      expect(Model.columns.detect { |c| c.name == 'state' }.default).to eql('pending')
    end
  end
end
