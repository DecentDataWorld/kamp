namespace :update_user_roles do

  desc "demote mid to low"
  task demote_mid_to_low: :environment do
    result1 = ActiveRecord::Base.connection.execute("
    UPDATE users_roles 
    SET role_id = (
        SELECT id 
        FROM roles 
        WHERE name = 'member'
    ) 
    WHERE role_id = (
        SELECT id 
        FROM roles 
        WHERE name = 'moderator'
    );")
    puts "Updated #{result1.cmd_tuples} portal moderators to members"

    result2 = ActiveRecord::Base.connection.execute("
        UPDATE users_organizations
        SET role = 'member'
        WHERE role = 'editor';
    ")
    puts "Updated #{result2.cmd_tuples} org editors to members"
  end

end
