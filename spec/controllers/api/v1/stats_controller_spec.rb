require "rails_helper"

describe Api::V1::StatsController do
  let(:user) { create(:user) }

  describe 'GET #total' do
    before(:each) do
      create(:customer, user: user)
      customer = create(:customer, user: user)
      3.times do
        create(
          :transaction,
          user: user,
          customer: customer,
          created_at: Time.now - 30 * 24 * 60 * 60,
          expiry: Time.now - 30 * 24 * 60 * 60
        )
      end

      3.times do
        create(:transaction, user: user, customer: customer, expiry: Time.now)
      end

      api_authorization_header(user)
      get :total
    end

    it "returns all time statistics" do
      stat_response = json_response
      expect(stat_response[:total_customers]).to eql 2
      expect(stat_response[:total_transactions]).to eql 6
      expect(stat_response[:total_gains]).to eql 1200
      is_expected.to respond_with 200
    end
  end

  describe 'GET #month' do
    before(:each) do
      create(:customer, user: user)
      customer = create(:customer, user: user)
      3.times do
        create(
          :transaction,
          user: user,
          customer: customer,
          created_at: Time.now - 30 * 24 * 60 * 60,
          expiry: Time.now - 30 * 24 * 60 * 60
        )
      end

      3.times do
        create(:transaction, user: user, customer: customer, expiry: Time.now)
      end

      api_authorization_header(user)
      get :month
    end

    it "returns currrent month's statistics" do
      stat_response = json_response
      expect(stat_response[:month_customers]).to eql 2
      expect(stat_response[:month_transactions]).to eql 3
      expect(stat_response[:month_gains]).to eql 600
      is_expected.to respond_with 200
    end
  end

  describe 'POST #customers' do
    before(:each) do
      create(:customer, user: user)
      customer = create(:customer, user: user)
      3.times do
        create(
          :transaction,
          user: user,
          customer: customer,
          created_at: Time.now - 30 * 24 * 60 * 60,
          expiry: Time.now - 30 * 24 * 60 * 60
        )
      end
      3.times do
        create(:transaction, user: user, customer: customer, expiry: Time.now)
      end

      api_authorization_header(user)
      get :customers
    end

    it "returns customers sorted by number of transactions" do
      stat_response = json_response[:stats]
      expect(stat_response.length).to eql 2
      expect(stat_response.first[:transactions_count]).to eql 6
      expect(stat_response.last[:transactions_count]).to eql 0
      is_expected.to respond_with 200
    end
  end
end
