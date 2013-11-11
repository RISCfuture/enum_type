require 'active_support/core_ext/module/aliasing'
require 'active_record/connection_adapters/postgresql_adapter'

# Patch the PostgreSQL adapter to recognize defaults on ENUM columns.

class ActiveRecord::ConnectionAdapters::PostgreSQLColumn

  def initialize(name, default, oid_type, sql_type = nil, null = true)
    @oid_type     = oid_type
    default_value = self.class.extract_value_from_default(default, sql_type)

    if sql_type =~ /\[\]$/
      @array = true
      super(name, default_value, sql_type[0..sql_type.length - 3], null)
    else
      @array = false
      super(name, default_value, sql_type, null)
    end

    @default_function = default if has_default_function?(default_value, default)
    @type ||= :string #TODO this is scary
  end

  def self.extract_value_from_default_with_enum(default, type=nil)
    return extract_value_from_default_without_enum(default) unless type
    case default
      when /\A'(.*)'::(?:#{Regexp.escape type})\z/
        $1
      else
        extract_value_from_default_without_enum default
    end
  end

  class << self
    alias_method_chain :extract_value_from_default, :enum
  end
end if ActiveRecord::ConnectionAdapters::PostgreSQLColumn.methods.include?(:extract_value_from_default)

class ActiveRecord::ConnectionAdapters::JdbcColumn
  def initialize(config, name, default, *args)
    call_discovered_column_callbacks(config)
    super(name, enum_default_value(default, args.first), *args)
    init_column(name, default, *args)
  end

  def enum_default_value(default, type)
    case default
      when /\A'(.*)'::(?:#{Regexp.escape type})\z/
        $1
      else
        default_value default
    end
  end
end if defined?(ActiveRecord::ConnectionAdapters::JdbcColumn)
