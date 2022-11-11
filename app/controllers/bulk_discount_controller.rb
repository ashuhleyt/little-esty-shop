class BulkDiscountController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new 
    @bulk_discount = BulkDiscount.new
    @merchant = Merchant.find(params[:merchant_id])
  end
end