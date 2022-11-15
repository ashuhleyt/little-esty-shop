class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :item
  enum status: ["packaged", "pending", "shipped"]

  def item_name
    Item.find(self.item_id).name
  end

  def invoice_date
    Invoice.find(self.invoice_id).created_at.strftime("%A, %d %B %Y")
  end

  def self.highest_discount 
    joins(item: [merchant: :bulk_discounts])
    .select('MAX (bulk_discounts.discount * invoice_items.quantity * invoice_items.unit_price / 100.0) as discount_amount, invoice_items.id as id')
    .group(:id).sum(&:discount_amount)
  end
end 
