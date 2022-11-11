class BulkDiscountController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
    # require 'pry'; binding.pry
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(discount_params)
    @bulk_discount.save 
    redirect_to "/merchants/#{@merchant.id}/bulk_discount"
  end

  def show 
    
  end


  private
  def discount_params
    params.permit(:discount, :threshold)
  end
end