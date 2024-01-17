namespace :assign_cops do

  desc "assign usaid cop"
  # will fail if it attempts to insert duplicates due to db constraint
  task assign_usaid_cop: :environment do
    query = "
    insert into cops_users (cop_id, user_id, created_at, updated_at)
    select distinct (select id from cops where name = \'USAID COP\'), u.id, now(), now()
    from users u
    join users_organizations uo on u.id = uo.user_id
    join organizations o on uo.organization_id = o.id
    join organization_types ot on o.organization_type_id = ot.id
    where ot.organization_type = \'USAID Implementing Partner\'"
    
    cop_users = ActiveRecord::Base.connection.exec_query(query)
    
    p "Inserted Cops-Users"
  end

end
