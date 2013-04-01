class WhereIs < Sinatra::Base
  get '/' do
    password = YAML.load_file('password.yaml')['password']
    gmail = Gmail.new('wymer.12@gmail.com', password)
    @emails = gmail.inbox.emails

    haml :index
  end
end
