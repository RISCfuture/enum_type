require 'active_support/core_ext/module/aliasing'
require 'active_record/connection_adapters/postgresql_adapter'

# Patch the PostgreSQL adapter to recognize defaults on ENUM columns.

class ActiveRecord::ConnectionAdapters::PostgreSQLColumn
  def initialize(name, default, sql_type = nil, null = true)
    super(name, self.class.extract_value_from_default(default, sql_type), sql_type, null)
  end

  def self.extract_value_from_default_with_enum(default, type)
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
    super(name,enum_default_value(default, args.first),*args)
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
