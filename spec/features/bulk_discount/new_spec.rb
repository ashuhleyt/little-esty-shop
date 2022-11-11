require 'rails_helper'

RSpec.describe 'New Bulk Discount' do 
  before :each do 
    @merchant_1 = Merchant.create!(name: "Dave")
    @merchant_2 = Merchant.create!(name: "Kevin")

    @discount1 = BulkDiscount.create!(discount: 20, threshold: 5, merchant_id: @merchant_1.id)
    @discount2 = BulkDiscount.create!(discount: 30, threshold: 15, merchant_id: @merchant_1.id)
    @discount3 = BulkDiscount.create!(discount: 50, threshold: 25, merchant_id: @merchant_2.id)
    @discount4 = BulkDiscount.create!(discount: 10, threshold: 3, merchant_id: @merchant_2.id)
  end

  describe 'new bulk discount form' do 
    it 'I see a form to add a new bulk discount' do 
      visit "/merchants/#{@merchant_1.id}/bulk_discount/new"

      expect(find('form')).to have_content('Discount')
      expect(find('form')).to have_content('Threshold')
    end
  end
end