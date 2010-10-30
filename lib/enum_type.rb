# Adds the @enum_type@ method to a model.
#
# @example Basic usage
#   class MyModel < ActiveRecord::Base
#     extend EnumType
#     enum_type :status, %w( open closed flagged deleted )
#   end

module EnumType

  # Defines a field whose type is an enumeration. Values are stored as strings
  # in the backend (or your database's enumerated type), however in the Rails
  # level they are represented as symbols.
  #
  # @overload enum_type(field, ..., options={})
  #   @param [Symbol] field An enumerated field.
  #   @param [Hash] options A hash of options.
  #   @option options [true, false] :allow_nil (false) If @true@, a nil value
  #     is allowed.
  #   @option options [Array<String>] :values If given, restricts valid values
  #     to those in the given array.
  #
  # @example Enumerated field with restricted types
  #   enum_type :color, values: %w( red orange yellow green blue purple )

  def enum_type(*fields)
    options = fields.extract_options!
    fields.each do |field|
      define_method field do
        value = read_attribute(field)
        value ? value.to_sym : value
      end

      define_method :"#{field}=" do |value|
        write_attribute field, value.try(:to_s)
      end

      validates_presence_of(field) unless options[:allow_nil]
      validates_inclusion_of(field, in: options[:values]) if options[:values]
    end
  end
end
