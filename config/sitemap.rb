Sitemap::Generator.instance.load :host => "https://jordankmportal.com" do
  path :root
  path :faq
  path :about
  path :about_resource_types
  path :new_users
  path :disclaimer
  path :access_denied
  resources :resources, :params => { :subdomain => proc { |resource| !resource.private } }
  resources :collections
  resources :organizations
  resources :users
  path :new_search

  # Sample path:
  #   path :faq
  # The specified path must exist in your routes file (usually specified through :as).

  # Sample path with params:
  #   path :faq, :params => { :format => "html", :filter => "recent" }
  # Depending on the route, the resolved url could be http://mywebsite.com/frequent-questions.html?filter=recent.

  # Sample resource:
  #   resources :articles

  # Sample resource with custom objects:
  #   resources :articles, :objects => proc { Article.published }

  # Sample resource with search options:
  #   resources :articles, :priority => 0.8, :change_frequency => "monthly"

  # Sample resource with block options:
  #   resources :activities,
  #             :skip_index => true,
  #             :updated_at => proc { |activity| activity.published_at.strftime("%Y-%m-%d") }
  #             :params => { :subdomain => proc { |activity| activity.location } }

end
