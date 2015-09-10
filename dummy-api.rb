require 'sinatra'
require "json"

get '/resource.json' do
    content_type :json
    data = { users: [ make_user(1000001, 'hoge', [make_post(100002, 'hoge'), make_post(100003, 'foo') ]) ] }
    data.to_json
end

get '/users.json' do
    content_type :json
    data = [ make_user(1000001, 'hoge', [make_post(100002, 'hoge'), make_post(100003, 'foo') ]) ]
    data.to_json
end

def make_user(id, name, posts)
    { id: id, name: name, created_at: Time.now.to_i-3600, updated_at: Time.now.to_i, posts: posts }
end

def make_post(id, content)
    { id: id, content: content, created_at: Time.now.to_i-3600, updated_at: Time.now.to_i }
end
