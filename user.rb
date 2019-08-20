class User
  attr_reader :attributes, :sessions, :id

  def initialize(attributes:)
    @attributes = attributes
    @sessions   = attributes.delete(:sessions)
    @id         = attributes[:id].to_i
  end
end
