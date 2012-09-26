require 'rubygems'
require 'sinatra'
require 'json'

VALID_RESP_CACHE_CONTROL = %w(no-cache no-store must-revalidate max-age private public no-transform proxy-revalidate s-maxage)

get '/' do
  @directives = VALID_RESP_CACHE_CONTROL
  erb :index
end

post '/cache-control' do
  content_type :json

  directives = params.keys

  unless directives.all? { |d| VALID_RESP_CACHE_CONTROL.include? d }
    return 400
  end

  directives.map! do |d|
    d += '0' if d == 'max-age' or d == 's-maxage'
    d
  end

  response["Cache-Control"] = directives.join(', ')

  { :time => Time.now.to_i }.to_json
end
