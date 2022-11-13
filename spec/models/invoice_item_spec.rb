require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "Relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  before(:each) do
    @merchant1 = Merchant.create!(name: "Trey")
    @merchant2 = Merchant.create!(name: "Meredith")
    @merchant3 = Merchant.create!(name: "Mikie")

    @discount1 = BulkDiscount.create!(discount: 50, threshold: 1, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(discount: 30, threshold: 15, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(discount: 10, threshold: 25, merchant_id: @merchant2.id)
    @discount4 = BulkDiscount.create!(discount: 75, threshold: 3, merchant_id: @merchant2.id)

    @merchant_1_item_1 = @merchant1.items.create!(name: "Pencil", description: "Writing implement", unit_price: 1)

    @customer_1 = Customer.create!(first_name: "Bob", last_name: "Jones")
    datetime = DateTime.iso8601('2022-11-01', Date::ENGLAND)
    @customer_1_invoice_1 = @customer_1.invoices.create!(status: 1, created_at: datetime)

    @invoice_item_1 = InvoiceItem.create!(invoice: @customer_1_invoice_1, item: @merchant_1_item_1, quantity: 1, unit_price: 4, status: 2)
  end

  describe 'instance methods' do
    describe '#item_name' do
      it 'returns item name by invoice_item' do
        expect(@invoice_item_1.item_name).to eq(@merchant_1_item_1.name)
      end
    end

    describe '#invoice_date' do
      it 'returns invoice by invoice_id' do
        expect(Invoice.find(@invoice_item_1.invoice_id)).to eq(@customer_1_invoice_1)
      end

      it 'returns formatted date for invoice created_at' do
        expect(@invoice_item_1.invoice_date).to eq("Tuesday, 01 November 2022")
      end
    end

    describe '#discount_inv_items' do 
      it 'returns an array of inv items that qualify for the discount' do 
        expect(InvoiceItem.discount_inv_items).to eq([@invoice_item_1])
      end
    end
  end
end