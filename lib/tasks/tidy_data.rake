namespace :tidy_data do

  desc "assign default org type"
  task assign_default_org_type: :environment do
    organization_type_id = OrganizationType.find_or_create_by(organization_type: "Other").id
    count = Organization.where(organization_type_id: nil).update_all(organization_type_id: organization_type_id)
    
    p "Updated #{count} Organizations"
  end

end
