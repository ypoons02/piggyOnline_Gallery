class User < ActiveRecord::Base
  has_secure_password # it adds 2 methods to user objects
  has_many :like, :class_name => 'Like', :foreign_key => 'user_id'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
end
