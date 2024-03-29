class WhereIs::Checkin
  include DataMapper::Resource

  property :id, Serial
  property :message, String
  property :timestamp, DateTime
  property :lat, Float
  property :lng, Float
  belongs_to :person

  before :save, :set_geo_name

  def set_geo_name
    params = { username: 'dimagi',
               password: 'dimagi',
               type: 'json',
               maxRows: '1',
               q: message }

    response = HTTParty.get("http://api.geonames.org/searchJSON", query: params)
    json = JSON.parse(response.body)
    location = json['geonames'].first

    if location
      self.lat = location['lat']
      self.lng = location['lng']
    end
  end
end
