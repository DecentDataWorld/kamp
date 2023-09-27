namespace :update_user_roles do

  desc "demote mid to low"
  task demote_mid_to_low: :environment do
    result1 = ActiveRecord::Base.connection.execute("
    INSERT INTO users_roles (user_id, role_id)
      (
        SELECT u.id,
        (SELECT id FROM roles WHERE name = 'member')
    FROM users u
    LEFT JOIN users_roles ur ON u.id = ur.user_id
    WHERE ur IS NULL
    AND u.sign_in_count > 0)
    ;")
    puts "Updated #{result1.cmd_tuples} unassigned users to members"

    result2 = ActiveRecord::Base.connection.execute("
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
    puts "Updated #{result2.cmd_tuples} portal moderators to members"


    result3 = ActiveRecord::Base.connection.execute("
        UPDATE users_organizations
        SET role = 'member'
        WHERE role = 'editor';
    ")
    puts "Updated #{result3.cmd_tuples} org editors to members"
  end

end
