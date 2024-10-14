require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let(:user_password) { "secure" }
  let(:user) { create(:user, password: user_password) }
  let!(:user_token) { create(:user_token, user: user, token: user_valid_headers[:Authorization].split(" ").last) }
  let(:valid_params) {
    {
      session: {
        email: user.email,
        password: user_password
      }
    }
  }
  let(:invalid_params) {
    {
      session: {
        email: nil,
        password: nil
      }
    }
  }

  describe "POST #create" do
    context "invalid parameters" do
      before { post sign_in_path, headers: without_auth_headers, params: invalid_params.to_json }

      it "should return http status 401 Unauthorized" do
        expect(response).to have_http_status(401)
        expect(response.message).to eq("Unauthorized")
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password")
      end
    end

    context "valid parameters" do
      before { post sign_in_path, headers: without_auth_headers, params: valid_params.to_json }

      it "should return http status 201 Created" do
        expect(response).to have_http_status(201)
        expect(response.message).to eq("Created")
        expect(JSON.parse(response.body)["message"]).to eq("Login successful")
      end
    end
  end

  describe "DELETE #destroy" do
    context "invalid parameters" do
      context "invalid token" do
        before { delete sign_out_path, headers: user_valid_headers.merge!({ "Authorization": "Bearer invalid-user-token" }) }

        it "should return http status 401 Unauthorized" do
          expect(response).to have_http_status(401)
          expect(response.message).to eq("Unauthorized")
        end
      end

      context "without Authorization headers" do
        before { delete sign_out_path, headers: without_auth_headers }

        it "should return http status 401 Unauthorized" do
          expect(response).to have_http_status(401)
          expect(response.message).to eq("Unauthorized")
        end
      end
    end

    context "valid parameters" do
      before { delete sign_out_path, headers: user_valid_headers }

      it "should return http status 204 No Content" do
        expect(response).to have_http_status(204)
      end
    end
  end
end
