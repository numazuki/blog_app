class Article < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
  has_many :images, dependent: :destroy
  has_many :tags, through: :tag_article
  has_many :tag_articles, dependent: :destroy   
  accepts_nested_attributes_for :images, allow_destroy: true
end
