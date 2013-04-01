class WhereIs < Sinatra::Base
  class Checkin
    include DataMapper::Resource

    property :id, Serial
    property :email, String
    property :message, String
    property :timestamp, DateTime
    property :lat, Float
    property :lng, Float
  end

  get '/' do
    @checkins = Checkin.all

    haml :index
  end

  def get_geo_name(message)
    params = { username: 'dimagi',
               password: 'dimagi',
               type: 'json',
               maxRows: '1',
               q: message }

    response = HTTParty.get("http://api.geonames.org/searchJSON", query: params)
    json = JSON.parse(response.body)
    location = json['geonames'].first
    return { lat: location['lat'], lng: location['lng'] }
  end

  get '/update' do
    password = YAML.load_file('password.yaml')['password']
    gmail = Gmail.new('wymer.12@gmail.com', password)

    gmail.inbox.emails.each do |email|
      geo_data = get_geo_name(email.subject)
      data = { email:  email.from.first,
               message: email.subject,
               timestamp: email.date,
               lat: geo_data[:lat],
               lng: geo_data[:lng] }
      checkin = Checkin.new(data)

      # only remove it if it saved
      if checkin.save
        email.archive!
      end
    end

    redirect '/'
  end
end
