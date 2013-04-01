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
    person = Person.first_or_create(:email => params[:email])

    data = { message: params[:message],
             timestamp: Time.now }
    checkin = person.checkins.new(data)

    if checkin.save
      redirect '/'
    end
  end

  get '/people' do
    @people = Person.all

    haml :'people/index'
  end

  get '/people/:id' do
    @person = Person.get(params[:id])

    haml :'people/show'
  end

  get '/update' do
    password = YAML.load_file('password.yaml')['password']
    gmail = Gmail.new('wymer.12@gmail.com', password)

    gmail.inbox.emails.each do |email|
      person = Person.first_or_create(:email => checkin.email)

      data = { email:  email.from.first,
               message: email.subject,
               timestamp: email.date }
      checkin = person.checkins.new(data)

      # only remove it if it saved
      if checkin.save
        email.archive!
      end
    end

    redirect '/'
  end
end
