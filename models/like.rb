class Like < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'id'
  belongs_to :art, :class_name => 'Art', :foreign_key => 'id'
end
