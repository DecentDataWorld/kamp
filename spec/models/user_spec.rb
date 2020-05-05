require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "Changem3!",
      :password_confirmation => "Changem3!"
    }
  end

  describe 'associations' do
    it { should belong_to(:user_type) }
    it { should have_many(:survey_logs) }
    it { should have_many(:resources) }
    it { should have_many(:batches) }
    it { should have_many(:collections_authored) }
    it { should have_many(:collections_maintaining) }
    it { should have_many(:organization_applications) }
    it { should have_many(:organizations) }
    it { should have_many(:users_organizations) }
    it { should have_many(:subscriptions) }
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

end
