class Comment < ActiveRecord::Base
  belongs_to :post

  validates_presence_of :nickname, :message, :post_id
end
