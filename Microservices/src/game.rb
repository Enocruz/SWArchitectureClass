require 'net/http'
require 'json'
 
URL_MICROSERVICE_PLAYER = 'http://localhost:8081/'

# From “Code example of using REST in Ruby on Rails” by LEEjava
# https://leejava.wordpress.com/2009/04/10/code-example-to-use-rest-in-ruby-on-rails/
#
module RESTful
   
  def self.get(url)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    resp = http.send_request('GET', uri.request_uri)
    resp.body
  end
 
  def self.post(url, data, content_type)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    http.send_request('POST', uri.request_uri, data, 'Content-Type' => content_type)
  end
 
  def self.put(url, data, content_type)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    http.send_request('PUT', uri.request_uri, data, 'Content-Type' => content_type)
  end
 
  def self.delete(url)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    http.send_request('DELETE', uri.request_uri)
  end
end

def create_player
  RESTful.post("#{URL_MICROSERVICE_PLAYER}/create_player", {'name' => 'Brandon'}.to_json, 'application/json')
end

create_player
