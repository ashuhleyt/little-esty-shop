class BulkDiscountController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(discount_params)
    @bulk_discount.save 
    redirect_to merchant_bulk_discount_index_path(@merchant.id)
  end

 def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discount_index_path(@merchant.id)
  end

  def edit 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    redirect_to merchant_bulk_discount_path(@merchant.id, @bulk_discount.id)
  end


  private
  def discount_params
    params.permit(:discount, :threshold)
  end
end