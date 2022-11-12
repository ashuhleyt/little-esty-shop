require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do 
  before :each do 
    @merchant_1 = Merchant.create!(name: "Dave")
    @merchant_2 = Merchant.create!(name: "Kevin")

    @discount1 = BulkDiscount.create!(discount: 20, threshold: 5, merchant_id: @merchant_1.id)
    @discount2 = BulkDiscount.create!(discount: 30, threshold: 15, merchant_id: @merchant_1.id)
    @discount3 = BulkDiscount.create!(discount: 50, threshold: 25, merchant_id: @merchant_2.id)
    @discount4 = BulkDiscount.create!(discount: 10, threshold: 3, merchant_id: @merchant_2.id)
    visit edit_merchant_bulk_discount_path(@merchant_1, @discount1)
  end

  describe 'bulk discount edit' do 
    describe 'form with existing attributes' do 
      it 'will display the form with existing discount attributes' do 
        expect(page).to have_field(:discount, with: @discount1.discount)
        expect(page).to have_field(:threshold, with: @discount1.threshold)

        fill_in('Discount', with: '25')
        fill_in('Threshold', with: '25')   
        click_button 'Save'

        expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount1))
      end
    end
  end
end 