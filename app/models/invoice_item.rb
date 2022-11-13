class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  enum status: ["packaged", "pending", "shipped"]

  def item_name
    Item.find(self.item_id).name
  end

  def invoice_date
    Invoice.find(self.invoice_id).created_at.strftime("%A, %d %B %Y")
  end

  def self.discount_inv_items 
    joins(item: [merchant: :bulk_discounts])
    .where("invoice_items.quantity >= bulk_discounts.threshold")
    .group(:id)
    # require 'pry'; binding.pry
  end
end