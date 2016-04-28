module Api
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer, only: [:show, :update, :destroy]
      before_action :authenticate_with_token, only: [
        :create,
        :index,
        :show,
        :update,
        :destroy
      ]
      respond_to :json

      def show
        render json: @customer
      end

      def index
        @customers = Customer.all
        render json: @customers
      end

      def create
        customer = current_user.customers.build(customer_params)
        if customer.save
          render json: customer, status: 201, location: [:api, customer]
        else
          render json: { error: "Customer not created" }, status: 422
        end
      end

      def update
        if @customer.update(customer_params)
          render json: @customer, status: 201, location: [:api, @customer]
        else
          render json: { error: "Customer not created" }, status: 422
        end
      end

      def destroy
        if @customer.destroy
          render json: { message: "Record deleted" }, status: 204
        end
      end

      private

      def set_customer
        @customer ||= Customer.find(params[:id])
      end

      def customer_params
        params.require(:customer).permit(:name, :phone, :referer, :user)
      end
    end
  end
end
