require "rails_helper"

describe Api::V1::CustomersController do
  describe 'GET #show' do
    before(:each) do
      user = create :user
      @customer = create(:customer, user: user)
      api_authorization_header(user)
      get :show, id: @customer.id
    end

    it "expect to see customer details" do
      customer_response = json_response[:customer]
      expect(customer_response[:name]).to eql @customer.name
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      user = create(:user)
      api_authorization_header(user)
      4.times { create(:customer, user: user) }
      get :index
    end

    it do
      customer_response = json_response
      expect(customer_response[:customers].length).to eql(4)
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context "when successfully created" do
      before(:each) do
        user = create(:user)
        @customer_attributes = attributes_for(:customer, user: user)
        api_authorization_header(user)
        post :create, customer: @customer_attributes
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response[:customer]
        expect(customer_response[:phone]).to eql @customer_attributes[:phone]
      end

      it { should respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        user = create(:user)
        @customer_attributes = attributes_for(:customer, phone: nil, user: user)
        api_authorization_header(user)
        post :create, customer: @customer_attributes
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response
        expect(customer_response[:error]).to eql "Customer not created"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PATCH #update' do
    context "when successfully updated" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        @customer_attr = attributes_for(:customer, name: "Adebee")
        api_authorization_header(user)
        patch :update, id: @customer.id, customer: @customer_attr
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response[:customer]
        expect(customer_response[:name]).to eql @customer_attr[:name]
      end

      it { should respond_with 201 }
    end

    context "when not updated" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        @customer_attr = attributes_for(:customer, name: "")
        api_authorization_header(user)
        patch :update, id: @customer.id, customer: @customer_attr
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response
        expect(customer_response[:error]).to eql "Customer not created"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    context "when successfully deleted" do
      before(:each) do
        user = create(:user)
        @customer = create(:customer, user: user)
        api_authorization_header(user)
        delete :destroy, id: @customer.id
      end

      it "renders the json attributes of the new record" do
        customer_response = json_response
        expect(customer_response[:message]).to eql "Record deleted"
      end

      it { should respond_with 204 }
    end
  end
end