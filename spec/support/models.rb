class User
  include LazyAsJson::AttributeFilter

  attr_accessor :id, :first_name, :last_name, :companies, :email

  def initialize(attrs = {})
    attrs.each { |k, v| send(:"#{k}=", v) }
  end

  def as_json(opts = {})
    {id: id}
  end
end

class Company
  include LazyAsJson::AttributeFilter
  attr_accessor :id, :name, :location, :address

  def initialize(attrs = {})
    attrs.each { |k, v| send(:"#{k}=", v) }
  end

  def as_json(opts = {})
    {id: id}
  end
end