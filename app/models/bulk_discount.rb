class BulkDiscount < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items 
end