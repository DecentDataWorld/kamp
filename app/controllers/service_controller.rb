class ServiceController < ApplicationController
  def index

    gibbon = Gibbon::Request.new

    @members = gibbon.lists("eefe93a3fe").members.retrieve(params: {count: "150"})

    @users_found = 0
    @users_not_found = 0

    @members["members"].each do |member|
      user = User.find_by :email => member["email_address"]
      if !user.nil?
        @users_found = @users_found + 1
        user.mail_chimp_user = true
        user.save
      else
        puts member["email_address"] + " not found"
        @users_not_found = @users_not_found + 1
      end
    end

    render :layout => false
  end
end
