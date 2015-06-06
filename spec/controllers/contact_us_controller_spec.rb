require 'spec_helper'

describe ContactUsController do
  describe 'POST create' do
    context "with valid input" do
      it "set the notice message" do
        post :create, subject: "Hello", name: "Bar Refaeli",email: "barrefaeli@gmail.com" ,message: "having fun here"
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid input" do
      it "set the error message" do
        params = {}
        params[:name] = 'Bar Refaeli'
        params[:email] = 'BarRefaeli@gmail.com'
        params[:subject] = "love ya"
        params[:message] = 'Hello.. nice to be in this amazing website!!'
        params[[:name,:email,:message,:subject].sample] = [nil, ""].sample
        post :create, params
        expect(flash[:error]).to be_present
      end
    end
  end
end