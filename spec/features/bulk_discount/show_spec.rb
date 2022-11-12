require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do 
  before :each do 
    @merchant_1 = Merchant.create!(name: "Dave")
    @merchant_2 = Merchant.create!(name: "Kevin")

    @discount1 = BulkDiscount.create!(discount: 20, threshold: 5, merchant_id: @merchant_1.id)
    @discount2 = BulkDiscount.create!(discount: 30, threshold: 15, merchant_id: @merchant_1.id)
    @discount3 = BulkDiscount.create!(discount: 50, threshold: 25, merchant_id: @merchant_2.id)
    @discount4 = BulkDiscount.create!(discount: 10, threshold: 3, merchant_id: @merchant_2.id)
    visit merchant_bulk_discount_path(@merchant_1, @discount1)
  end

  describe 'bulk discount show' do 
    it 'I see the bulk discount threshold and percentage discount' do 
      expect(page).to have_content(@discount1.discount)
      expect(page).to have_content(@discount1.threshold)
    end

    it 'I see a link to edit the bulk discount' do 
      expect(page).to have_link("Edit #{@discount1.id}")
    end

    it 'I see a link to edit the bulk discount' do 
      click_link "Edit #{@discount1.id}"

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @discount1))
    end
  end
end