class Admin::MerchantsController < ApplicationController
  def index 
    
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update!(    name: params[:name])
    redirect_to(admin_merchant_path(@merchant.id))
    flash[:notice] = "#{@merchant.name} has been successfully updated"
  end
end
