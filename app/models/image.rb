class Image < ApplicationRecord
  belongs_to :article, optional: true
  belongs_to :draft, optional: true
  mount_uploader :image, ImageUploader
end
