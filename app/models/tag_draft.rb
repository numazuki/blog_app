class TagDraft < ApplicationRecord
  belongs_to :draft
  belongs_to :dtag  
end
