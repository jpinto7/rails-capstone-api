require 'rails_helper'

RSpec.describe "ApiDevelopments", type: :request do

  def parsed_body
    JSON.parse(response.body)
  end

  describe "RDBMS-backed" do
    before(:each) { City.delete_all }
    after(:each) { City.delete_all }

    it "create RDBMS-backed model" do
      city = City.create(name: 'Baltimore')
      expect(City.find_by(id: city).name).to eq('Baltimore')
    end

    it "expose RDBMS-backed API resource" do
      city = City.create(name: 'New York')
      expect(cities_path).to eq('/api/cities')
      get city_path(city)
      expect(response).to have_http_status(:ok)
      expect(parsed_body['name']).to eq('New York')
    end
  end

  describe "MongoDB-backed" do
    before(:each) { State.delete_all }
    after(:each) { State.delete_all }

    it "create MongoDB-backed model" do
      state = State.create(name: 'Maryland')
      expect(State.find_by(id: state).name).to eq('Maryland')
    end

    it "expose MongoDB-backed API resource" do
      state = State.create(name: 'California')
      expect(states_path).to eq('/api/states')
      get state_path(state)
      expect(response).to have_http_status(:ok)
      expect(parsed_body['name']).to eq('California')
      expect(parsed_body).to include('created_at')
    end
  end
end
