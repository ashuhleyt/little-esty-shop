require "rails_helper"
require "date"

RSpec.describe "Admin Invoice show page" do 
  before(:each) do 
    merchant = Merchant.create!(name: "Practical Magic Shop")
    @merchant_1 = Merchant.create!(name: "Dave")
    @merchant_2 = Merchant.create!(name: "Kevin")

    @discount1 = BulkDiscount.create!(discount: 20, threshold: 5, merchant_id: @merchant_1.id)
    @discount2 = BulkDiscount.create!(discount: 30, threshold: 15, merchant_id: @merchant_1.id)
    @discount3 = BulkDiscount.create!(discount: 50, threshold: 25, merchant_id: @merchant_2.id)
    @discount4 = BulkDiscount.create!(discount: 10, threshold: 3, merchant_id: @merchant_2.id)

    @book = merchant.items.create!(name: "Book of the dead", description: "book of necromancy spells", unit_price: 4)
    @candle = merchant.items.create!(name: "Candle of life", description: "candle that gifts everlasting life", unit_price: 15)
    @potion = merchant.items.create!(name: "Love potion", description: "One serving size of true love potion", unit_price: 10)
    @fork = @merchant_1.items.create!(name: "Dinglehopper", description: "eating utensil", unit_price: 2)
  
    @merchant_1_item_1 = @merchant_1.items.create!(name: "Pencil", description: "Writing implement", unit_price: 1)
    @merchant_1_item_2 = @merchant_1.items.create!(name: "Mechanical Pencil", description: "Writing implement", unit_price: 3)
    @merchant_2_item_1 = @merchant_2.items.create!(name: "A Thing", description: "Will do the thing", unit_price: 2)

    @customer = Customer.create!(first_name: "Gandalf", last_name: "Thegrey")
    feb_third = DateTime.new(2022,2,3,4,5,6)
    march_third = DateTime.new(2022,3,3,6,2,3)

    @invoice_1 = @customer.invoices.create!(status: 2, created_at: feb_third)
    @invoice_2 = @customer.invoices.create!(status: 1, created_at: march_third)

    InvoiceItem.create!(invoice: @invoice_1, item: @fork, quantity: 8, unit_price: 2, status: 1)
    InvoiceItem.create!(invoice: @invoice_1, item: @book, quantity: 1, unit_price: 4, status: 1)
    InvoiceItem.create!(invoice: @invoice_1, item: @candle, quantity: 2, unit_price: 15, status: 2)
    InvoiceItem.create!(invoice: @invoice_2, item: @potion, quantity: 3, unit_price: 10, status: 2)
  end

  describe "As an admin, when I visit admin/invoices/:id" do 
    it "shows information related to that invoice including, id, status, created_at date, and Customer first and last name" do       
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_content("Status:")
      expect(page).to have_content("Created on: Thursday, February 03, 2022")
      expect(page).to have_content("Customer:")
      expect(page).to have_content("Gandalf Thegrey")
    end

    it "lists all the items on the invoice including: item name, quantity, price, and the Invoice Item status" do 
      visit admin_invoice_path(@invoice_1)

      within "#items-details" do 
        expect(page).to have_content("Items on this Invoice:")
        expect(page).to have_content("Item Name")
        expect(page).to have_content("Quantity")
        expect(page).to have_content("Unit Price")
        expect(page).to have_content("Status")

        expect(page).to have_content("Book of the dead")
        expect(page).to have_content("2")
        expect(page).to have_content("4")
        expect(page).to have_content("pending")

        expect(page).to have_content("Candle of life")
        expect(page).to have_content("2")
        expect(page).to have_content("15")
        expect(page).to have_content("shipped")
      end
    end

    it "displays the invoice status as a select field, with the current status selected" do 
      visit admin_invoice_path(@invoice_1)

      expect(page).to have_select("invoice_status")
      expect(page).to have_select(selected: "In Progress")
      expect(page).to have_button("Update Invoice Status")
    end

    it "when I click Update Invoice Status, the admin invoice show page reloads and see the status has been updated" do 
      visit admin_invoice_path(@invoice_1)

      select 'Completed', from: 'invoice_status'
      click_button("Update Invoice Status")

      expect(current_path).to eq(admin_invoice_path(@invoice_1))
      expect(page).to have_select(selected: "Completed")
    end
  end
  
  describe 'As an admin, when I visit an admin invoice show page' do 
    it 'I see the total revenue that will be generated from this invoice' do 
      merchant1 = Merchant.create!(name: "Trey")
      customer1 = Customer.create!(first_name: "Bobby", last_name: "Valentino")
      merchant_1_item_1 = merchant1.items.create!(name: "Straw", description: "For Drinking", unit_price: 2)
      merchant_1_item_2 = merchant1.items.create!(name: "Plant", description: "Fresh Air", unit_price: 1)
      customer_1_invoice_1 = customer1.invoices.create!(status: 1)
      InvoiceItem.create!(invoice: customer_1_invoice_1, item: merchant_1_item_1, quantity: 1, unit_price: 3, status: 2)
      InvoiceItem.create!(invoice: customer_1_invoice_1, item: merchant_1_item_2, quantity: 4, unit_price: 6, status: 2)
      
      visit "admin/invoices/#{customer_1_invoice_1.id}"
      
      expect(page).to have_content("Total Revenue: $27")
    end

    it 'I see the total discounted revenue from this invoice' do
       visit admin_invoice_path(@invoice_1)
      expect(page).to have_content("Total Discounted Revenue:")
    end
  end
end