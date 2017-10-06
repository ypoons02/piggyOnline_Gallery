require 'sinatra'
#require 'sinatra/reloader'
require 'pg'
require 'pry'
#require 'email_verifier'

require_relative 'db_config'
require_relative 'models/artPiece'
require_relative 'models/user'
require_relative 'models/like'

enable :sessions # sinatra provides this feature

#EmailVerifier.config do |config|
#  config.verifier_email = "realname@realdomain.com"
#end

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
  def logged_in?
    if current_user
      return true
    else
      return false
    end
  end
end

get '/' do
  @artPiece = Art.all
  erb :index
end

get '/mainview' do
  redirect '/index' unless logged_in?
  checkedID = session[:user_id]
  session[:user_id] = nil

  session[:user_id] = checkedID
  erb :mainView
end

get '/viewAll' do
  redirect '/' unless logged_in?
  checkedID = session[:user_id]
  session[:user_id] = nil
  user = User.find(checkedID)
  @user = user.email
  @like = []

  @like = Like.where('user_id IN (?)',checkedID)
  if @like == []
    @artPiece = Art.all
  else
    likeArray = []
    @like.each do |like|
      likeArray.push(like.artpiece_id)
    end
    @artPiece = Art.where('id NOT IN (?)',likeArray)
  end
  if @artPiece == []
    @message  = "WOW... You have liked every art pieces we got. Watch at this space and come back for more!"
  end
  session[:user_id] = checkedID
  erb :viewAll
end

get '/myLikes' do
  redirect '/' unless logged_in?
  checkedID = session[:user_id]
  session[:user_id] = nil

  @user = User.find(checkedID)
  @like = Like.where('user_id IN (?)',checkedID)

  likeArray = []

  @like.each do |like|
    likeArray.push(like.artpiece_id)
  end

  @artPiece = Art.where('id IN (?)',likeArray)
  session[:user_id] = checkedID

  if likeArray == []
    @message  = "You have no art pieces you like. Start adding them!"
  end

  erb :myLikes
end

get '/art/:id' do
  redirect '/' unless logged_in?
  checkedID = session[:user_id]
  session[:user_id] = nil

  @artPiece = Art.find(params[:id])
  @like = Like.where('artpiece_id IN (?)', [params[:id]])
  @user = User.all

  @age_below20 = 0
  @age_20To30 = 0
  @age_30To40 = 0
  @age_above40 = 0

  @genderMale = 0
  @genderFemale = 0

  @like.each do |like|

    user = User.find(like.user_id)

    birthDate = user.birthdate
    today = Date.today
    d = Date.new(today.year, birthDate.month, birthDate.day)
    age = d.year - birthDate.year - (d > today ? 1 : 0)

    case age
      when 0..20 then
        @age_below20 = @age_below20.to_i ＋1
      when 20..30 then
        @age_20To30 = @age_20To30.to_i + 1
      when 30..40 then
        @age_30To40 = @age_30To40.to_i ＋ 1
      when 40..100 then
        @age_above40 = @age_above40.to_i + 1
      else
    end

    gender = user.gender

    if gender == 'F'
      @genderFemale = @genderFemale + 1
    else
      @genderMale = @genderMale + 1
    end

  end

  #calc %
  @totalUsers_likes = @age_below20 + @age_20To30 + @age_30To40 + @age_above40

  if @totalUsers_likes == 0
    @age_below20_percent = 0
    @age_20To30_percent = 0
    @age_30To40_percent = 0
    @age_above40_percent = 0

    @genderMale_percent = 0
    @genderFemale_percent = 0
  else
    @age_below20_percent = (@age_below20.to_f / @totalUsers_likes.to_f * 100.0).round
    @age_20To30_percent = (@age_20To30.to_f / @totalUsers_likes.to_f * 100.0).round
    @age_30To40_percent = (@age_30To40.to_f / @totalUsers_likes.to_f * 100.0).round
    @age_above40_percent = (@age_above40.to_f / @totalUsers_likes.to_f * 100.0).round

    @genderMale_percent = (@genderMale.to_f / @totalUsers_likes.to_f * 100).round
    @genderFemale_percent = (@genderFemale.to_f / @totalUsers_likes.to_f * 100).round
  end
  session[:user_id] = checkedID
  erb :art

end
#========================like items=======================
get '/art/:id/changeToLiked' do
  redirect '/' unless logged_in?
  checkedID = session[:user_id]
  session[:user_id] = nil
  @user = User.find_by(id: checkedID)
  like = Like.where('user_id = ? AND artpiece_id = ?', checkedID, params[:id])

  Like.create!(:user_id => checkedID, :artpiece_id => params[:id])

  session[:user_id] = checkedID
  redirect '/viewAll'
end

#========================unlike items=======================
get '/art/:id/changeToUnliked' do
  redirect '/' unless logged_in?
  checkedID = session[:user_id]
  session[:user_id] = nil
  @user = User.find_by(id: checkedID)
  like = Like.where('user_id = ? AND artpiece_id = ?', checkedID, params[:id])

  primarykey = like.ids
  destoryLike = Like.find(primarykey[0])
  destoryLike.destroy

  session[:user_id] = checkedID
  redirect '/myLikes'
end

#========================SignUp=======================
post '/signup' do
  user = User.find_by(email: params[:signUp_email])
  if user
    @messageSignup = 'Email exist. Please login.'
    erb :index
  else
    email = params[:signUp_email]
    password  = params[:signUp_password]
    country  = params[:signUp_country]
    birthdate  = params[:signUp_birthdate]
    gender  = params[:signUp_gender]

    #create record
    createRecord = true
    begin
      User.create!(:email => email, :password => password, :country => country, :birthdate => birthdate, :gender => gender)
    rescue ActiveRecord::RecordInvalid => invalid
      err = invalid.record.errors
      err.each do |error|
          @messageSignup = "Invalid #{error}. Please check your entry."
          createRecord = false
      end
    end
    if createRecord
      user = User.find_by_email(email)
      user.save!
      @messageSignup = 'Sign up complete! Please login.'
    end
    erb :index
  end
end
#========================Login=======================
post '/session' do
  # find the user
  user = User.find_by(email: params[:email])
  #if found a user
  if user && user.authenticate(params[:password])
    # sucessful create session then redirect
    session[:user_id] = user.id
    redirect '/myLikes'
  else
    @message = 'Invalid email or password. Please check your entry.'
    erb :index
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end
