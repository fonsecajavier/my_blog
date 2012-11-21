class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy

  validates_presence_of :title, :content, :user_id
  attr_accessible :title, :content
end
