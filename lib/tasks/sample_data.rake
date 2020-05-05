namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do


    User.create!(name: "Test User",
                 email: "ucantspamme@gmail.com",
                 password: "dq3xbzrg0ff",
                 password_confirmation: "dq3xbzrg0ff")

    8.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@taimoor.us"
      password  = "dq3xbzrg0ff"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    Organization.create!(name: "MSI Worldwide",
                         description: "Management Systems International information goes here")

    10.times do |n|
      name  = Faker::Company.name
      description = Faker::Lorem.paragraph
      Organization.create!(name: name,
                           description: description)
    end

    UsersOrganization.create!(organization_id: 1,
                               user_id: 1)

    10.times do |n|
      org_id  = Faker::Number.digit
      user_id = Faker::Number.digit
      UsersOrganization.create!(organization_id: org_id,
                                 user_id: user_id)
    end

    Collection.create!(title: "Test Collection",
                    description: "This is a test collection",
                    author_id: Faker::Number.digit,
                    maintainer_id: Faker::Number.digit)

    20.times do |n|
      title  = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph
      author_id  = Faker::Number.digit
      maintainer_id  = Faker::Number.digit
      organization_id = Faker::Number.digit
      Collection.create!(title: title,
                      description: description,
                      author_id: author_id,
                      maintainer_id: maintainer_id,
                      organization_id: organization_id)
    end
  end
end