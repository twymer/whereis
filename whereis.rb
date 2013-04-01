class WhereIs < Sinatra::Base
  get '/' do
    @checkins = Checkin.all

    haml :index
  end

  get '/checkin' do
    @checkin = Checkin.new
    haml :'checkin/new'
  end

  post '/checkin' do
    data = { email: params[:email],
             message: params[:message],
             timestamp: Time.now }
    checkin = Checkin.new(data)

    if checkin.save
      redirect '/'
    end
  end

  get '/update' do
    password = YAML.load_file('password.yaml')['password']
    gmail = Gmail.new('wymer.12@gmail.com', password)

    gmail.inbox.emails.each do |email|
      data = { email:  email.from.first,
               message: email.subject,
               timestamp: email.date }
      checkin = Checkin.new(data)

      # only remove it if it saved
      if checkin.save
        email.archive!
      end
    end

    redirect '/'
  end
end
