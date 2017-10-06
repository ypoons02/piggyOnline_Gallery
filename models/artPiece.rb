# conventions over configuration
class Art < ActiveRecord::Base
  has_many :like, :class_name => 'Like', :foreign_key => 'artpiece_id'
end
