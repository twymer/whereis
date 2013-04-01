class WhereIs < Sinatra::Base
  class Checkin
    include DataMapper::Resource

    property :id, Serial
    property :email, String
    property :message, String
    property :timestamp, DateTime
    property :location_guess, String
  end

  get '/' do
    @checkins = Checkin.all

    haml :index
  end

  get '/update' do
    password = YAML.load_file('password.yaml')['password']
    gmail = Gmail.new('wymer.12@gmail.com', password)

    gmail.inbox.emails.each do |email|
      data = { :email => email.from.first,
               :message => email.subject,
               :timestamp => email.date }
      checkin = Checkin.new(data)

      # only remove it if it saved
      if checkin.save
        email.archive!
      end
    end

    redirect '/'
  end
end
