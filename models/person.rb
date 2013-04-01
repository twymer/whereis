class WhereIs::Person
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  has n, :checkins
end
