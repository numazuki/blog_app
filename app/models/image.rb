class Image < ApplicationRecord
  belongs_to :articles, optional: true
  mount_uploader :image, ImageUploader
end
