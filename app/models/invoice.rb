class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  # has_many :bulk_discounts, through: :item
  # has_many :merchants, through: :item
  enum status: ["Cancelled", "Completed", "In Progress"]

  def self.incomplete_invoices
    where(status: "In Progress").order(:created_at)
  end

  def self.invoices_for(merchant)
    invoice_ids = merchant.invoice_items.pluck("invoice_id")
    Invoice.where(id: invoice_ids)
  end

  def customer_last
    self.customer.last_name
  end

  def customer_first
    self.customer.first_name
  end

  def total_revenue(merchant)
    self.items.where(merchant_id: merchant).sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def invoice_revenue
    self.invoice_items.sum("quantity * unit_price")
  end
 
  def applied_discount
    invoice_revenue - invoice_items.highest_discount
  end

  # def qualify_discount
  #   invoice_items.joins(item: [merchant: :bulk_discounts])
  #   .where('invoice_items.quantity >= bulk_discounts.threshold')
  # end
end 


