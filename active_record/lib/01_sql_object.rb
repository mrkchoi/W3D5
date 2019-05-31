require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
      
    @columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    @columns = @columns.first.map!(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |column|
      define_method("#{column}") do
        return attributes[column]
      end

      define_method("#{column}=") do |val|
        attributes[column] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |key, val|
      attr_name = key.to_sym
      
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", val)
      else
        raise "unknown attribute '#{attr_name.to_s}'"
      end
    end
    
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
