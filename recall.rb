# require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")
#datamapper sets up class as db table name 'notes'
class Note
  #setting up new SQLite3 DB with 5 fields
  include DataMapper::Resource
  #Serial = autoincrement
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!
#READ
get '/' do
  #instance var '@notes' so it's accessible from within the view file
  @notes = Note.all :order => :id.desc
  @title = 'All Notes'
  erb :home
end
# CREATE
post '/' do
  #new note creates a new node; new row in note table in DB
  n = Note.new
  #submitted note = content
  n.content = params[:content]
  # p params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id' do
  @note = Note.get params[:id]
  @title = "Edit note ##{params[:id]}"
  erb :edit
end
# UPDATE
put '/:id' do
  n = Note.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  n.save
  redirect '/'
end
#DELETE
get '/:id/delete' do
  @note = Note.get params[:id]
  @title = "Confirm deleteiong of note ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  n = Note.get params[:id]
  n.destroy
  redirect '/'
end

get '/:id/complete' do
  n = Note.get params[:id]
  n.complete = n.complete ? 0 : 1
  n.updated_at = Time.now
  n.save
  redirect '/'
end

