require 'sinatra'
require 'sinatra/reloader'
require 'csv'

def csv_import(filename)
  @results = []
  CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
    @results << row.to_hash
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

  csv_import('public/articles.csv')

  erb :articles
end

get '/submit' do

  csv_import('public/articles.csv')

  erb :submit
end


post '/submit' do

  title = params[:title]
  url = params[:url]
  des = params[:description]

  if post_is_valid?(params[:url])
    CSV.open('public/articles.csv', 'a') do |article|
      article << [title,url,des]
    end
    redirect '/'
  else
    error = "Invalid input"
    if !valid_url?(url)
      error = "Invalid url"
    end
    redirect '/'

    erb :submit
  end
end
