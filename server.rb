require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pry'
require 'pg'


def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')

    yield(connection)

  ensure
    connection.close
  end
end


def post_is_valid?(params_url_here)
  if !valid_url?(params_url_here)
    return false
  end
  true
end

def valid_url?(params_url_here)
  if params_url_here !~ (/^w{3}\.\w+\.(\.|\w){2,6}$/)
    return false
  end
  true
end

get '/' do
  sql = 'SELECT title, url, description FROM articles'

  @results = db_connection do |conn|
    conn.exec_params(sql).to_a
  end

  erb :articles
end



get '/submit' do

  sql = 'SELECT title, url, description FROM articles'

  @results = db_connection do |conn|
    conn.exec_params(sql).to_a
  end

  erb :submit
end


post '/submit' do

  title = params['title']
  url = params['url']
  des = params['description']

  sql = 'INSERT INTO articles (title, url, description) VALUES ($1, $2, $3)'


  db_connection do |conn|
    conn.exec_params(sql, [title, url, des]).to_a
  end

  # if post_is_valid?(params[:url])
  #   CSV.open('public/articles.csv', 'a') do |article|
  #     article << [title,url,des]
  #   end
  #   redirect '/'
  # else
  #   error = "Invalid input"
  #   if !valid_url?(url)
  #     error = "Invalid url"
  #   end
    redirect '/'

    erb :submit
end

post '/' do
  @input = []
  @input = @input << gets.chomp
  redirect 'http://www.google.com'
end

