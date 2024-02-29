namespace :tidy_data do

  desc "assign default org type"
  task assign_default_org_type: :environment do
    organization_type_id = OrganizationType.find_or_create_by(organization_type: "Other").id
    count = Organization.where(organization_type_id: nil).update_all(organization_type_id: organization_type_id)
    
    p "Updated #{count} Organizations"
  end

  desc "assign org admin as author of resources with invalid author_id"
  task assign_default_resource_author: :environment do
    resources = Resource.where.not(author_id: User.all.pluck(:id))
    resources_count = resources.count
    updated_count = 0
    resources.each do |r|
      if r.organization
        if r.organization.admins.length > 0
          # puts r.organization.admins.first.user.id
          r.author_id = r.organization.admins.first.user.id
          puts r.id
          if r.save
            updated_count = updated_count + 1
          else
            puts "Could not update resource #{r.id} due to a validation failure on save - rerun with save! to see failure"
          end
        else
          puts "Resource #{r.id} belongs to an organization (#{r.organization.id}) with no admins"
        end
      else
        puts "Resource #{r.id} has no valid organization"
      end
    end
    puts "Updated #{updated_count} out of #{resources_count} resources with invalid authors"
  end

  desc "assign org admin as author of collections with invalid author_id"
  task assign_default_collection_author: :environment do
    collections = Collection.where.not(author_id: User.all.pluck(:id))
    collections_count = collections.count
    updated_count = 0
    collections.each do |c|
      if c.organization
        if c.organization.admins.length > 0
          # puts c.organization.admins.first.user.id
          c.author_id = c.organization.admins.first.user.id
          c.maintainer_id = c.organization.admins.first.user.id
          puts c.id
          if c.save
            updated_count = updated_count + 1
          else
            puts "Could not update collection #{c.id} due to a validation failure on save - rerun with save! to see failure"
          end
        else
          puts "Collection #{c.id} belongs to an organization (#{c.organization.id}) with no admins"
        end
      else
        puts "Collection #{c.id} has no valid organization"
      end
    end
    puts "Updated #{updated_count} out of #{collections_count} collections with invalid authors"
  end

end
