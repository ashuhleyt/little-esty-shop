class BulkDiscount < ApplicationRecord
  belongs_to :merchant 

  validates :discount, presence: true, numericality: true
  validates :threshold, presence: true, numericality: { only_integer: true }
end