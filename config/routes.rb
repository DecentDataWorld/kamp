Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #mount Ckeditor::Engine => '/ckeditor'
  resources :banners
  get 'survey/index'
  get 'survey/done'
  get 'service/index'
  resources :denial_reasons, path: 'admin/denial_reasons'
  get 'moderator/index', to: 'moderator#index', as: :moderate_submissions
  get 'moderator/approve', to: 'moderator#approve', as: :approve_submission
  get 'moderator/denial', to: 'moderator#denial', as: :denial_submission
  post 'moderator/deny', to: 'moderator#deny', as: :deny_submission
  get 'moderator/denied', to: 'moderator#denied', as: :denied_submissions
  get 'moderator/users', to: 'moderator#users', as: :moderator_users

  resources :activities

  get 'resourcings/remove_resourcing', to: 'resourcings#remove_resourcing', as: :remove_resourcing
  resources :resourcings
  get 'resources/log_event', to: 'resources#log_event', as: :log_event
  get 'resources/download', to: 'resources#download', as: :download_resource

  resources :user_types, path: 'admin/user_types'
  resources :organization_types, path: 'admin/organization_types'

  #mount RailsAdmin::Engine => '/cpanel', as: 'rails_admin'

  #resources :batches
  #resources :categories
  resources :tags, path: 'admin/tags'
  get 'tags/guide', to: 'tags#show_guide', as: :show_guide
  resources :tag_types, path: 'admin/tag_types'
  resources :featured_searches
  resources :announcements, path: 'admin/announcements'
  get 'announcements', to: 'announcements#public_announcements', as: :public_announcements
  get 'announcements/:id', to: 'announcements#show_announcement', as: :show_announcement

  resources :cops, path: 'admin/cops'
  get 'cops/:id', to: 'cops#show_cop', as: :show_cop

  
  resources :events, path: 'admin/events'
  get 'events', to: 'events#public_events', as: :public_events
  get 'events/:id', to: 'events#show_event', as: :show_event

  get 'faq/index', to: 'faq#index', as: :faq
  resources :users_organizations
  put 'usersorganizations/update_org_role', to: 'users_organizations#update_org_role', as: :update_org_role

  get 'data/csv', to: 'data#csv', as: :data_csv
  #get 'contact', to: 'contact#index', as: :contact
  #get "contact/index"
  get 'about', to: 'about#index', as: :about
  get 'about/types', to: 'about#types', as: :about_resource_types
  get 'about/new_users', to: 'about#new_users', as: :new_users
  get 'about/disclaimer', to: 'about#disclaimer', as: :disclaimer
  get 'about/access_denied', to: 'about#access_denied', as: :access_denied
  get 'about/index'
  get 'admin/index'
  post 'admin/invite_user', to: 'admin#invite_user', as: :invite_user
  get 'admin/contest', to: 'admin#contest', as: :admin_contest
  get 'admin/resource_ratings', to: 'admin#resource_ratings', as: :resource_ratings
  get 'admin/collection_ratings', to: 'admin#collection_ratings', as: :collection_ratings
  get 'admin/survey_report', to: 'admin#survey_report', as: :survey_report
  get 'admin/contest_report', to: 'admin#contest_report', as: :contest_report
  get 'admin/access_report', to: 'admin#access_report', as: :access_report
  #get 'admin/manage_tags', to: 'admin#manage_tags', as: :manage_tags
  #get 'admin/delete_tag', to: 'admin#delete_tag', as: :delete_tag
  #get 'admin/edit_tag', to: 'admin#edit_tag', as: :edit_tag
  #get 'admin/new_tag', to: 'admin#new_tag', as: :new_tag
  #post 'admin/update_tag', to: 'admin#update_tag', as: :update_tag
  get 'admin/orgs', to: 'admin#orgs', as: :orgs
  get 'admin/upload_files', to: 'admin#upload_files', as: :upload_files
  get 'admin/private_resources', to: 'admin#private_resources', as: :private_resources
  get 'admin/pending_submissions', to: 'admin#pending_submissions', as: :pending_submissions
  post 'admin/process_uploaded_files', to: 'admin#process_uploaded_files', as: :process_uploaded_files
  get 'admin/fix_resource_collections_menu', to: 'admin#fix_resource_collections_menu', as: :fix_resource_collections_menu
  get 'admin/fix_resource_collections', to: 'admin#fix_resource_collections', as: :fix_resource_collections

  #get 'ViewerJS', :to => redirect('/ViewerJS/index.html')
  get 'resources/rate_resource', to: 'resources#rate_resource', as: :rate_resource
  get 'resources/not_found', to: 'resources#not_found', as: :resources_not_found
  get 'resources/preview/:id', to: 'resources#preview', as: :resource_preview
  resources :resources

  get 'searches/update_search', to: 'searches#update_search', as: :update_search
  resources :searches

  get 'collections/not_found', to: 'collections#not_found', as: :collections_not_found
  get 'collections/rate_collection', to: 'collections#rate_collection', as: :rate_collection
  resources :collections do
    resources :resourcings
  end
  get 'about/no_approved_org', to: 'about#no_approved_org', as: :no_approved_orgs

  resources :types

  resources :licenses

  get 'organizations/not_found', to: 'organizations#not_found', as: :organization_not_found
  get 'organizations/add_user/:organization', to: 'organizations#add_user', as: :organization_add_user
  get 'organizations/apply', to: 'organizations#apply', as: :organization_apply
  get 'organizations/edit_user/:userorg', to: 'organizations#edit_user', as: :users_organizations_edit_role
  get 'organizations/approve_organization/:organization', to: 'organizations#approve_organization', as: :organization_approve
  get 'organizations/process_application', to: 'organizations#process_application', as: :organization_process_application
  match 'organizations/process_application_denial' => 'organizations#process_application_denial', :as => :organizations_process_application_denial, :via => 'post'
  match 'organizations/add_user/:organization' => 'organizations#process_new_user', :as => :organizations_process_user, :via => 'post'
  post 'organizations/invite_user', to: 'organizations#invite_user', as: :org_invite_user
  get 'organizations/private_resources/:id', to: 'organizations#private_resources', as: :org_private_resources
  resources :organizations, path: '/admin/organizations'
  put 'organizations/deactivate/:id', to: 'organizations#deactivate', as: 'deactivate_organization'
  put 'organizations/reactivate/:id', to: 'organizations#reactivate', as: 'reactivate_organization'
  get 'user_orgs_index', to: 'organizations#user_orgs_index', as: 'user_orgs_index'

  root :to => 'home#index'
  get 'home/error', to: 'home#error', as: :error_page
  get 'tags/:tag', to: 'tags#index', as: :collection_tags
  post 'users/save_subscriptions/:id', to: 'users#save_subscriptions', as: :user_save_subscriptions
  post 'users/remove_subscription/:id', to: 'users#remove_subscription', as: :user_remove_subscription
  get 'users/unlock_user/:id', to: 'users#unlock_user', as: :unlock_user
  get 'users/get_users', to: 'users#get_users', as: :get_users
  get 'users/export', to: 'users#export', as: :users_export
  get 'request_invite', to: 'users#request_invite', as: :request_invite
  post 'users/send_invite', to: 'users#send_invite', as: :send_invite
  devise_for :users, :controllers => {:registrations => 'registrations'}, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  resources :users, path: 'admin/users'
  put 'users/deactivate/:id', to: 'users#deactivate', as: 'deactivate_user'
  put 'users/reactivate/:id', to: 'users#reactivate', as: 'reactivate_user'
  put 'users/remove_membership', to: 'users#remove_membership', as: :remove_membership
  put 'users/update_role', to: 'users#update_role', as: :update_role
  put 'users/remove_cop_membership', to: 'users#remove_cop_membership', as: :remove_cop_membership
  get '/unsubscribe', to: 'users#unsubscribe'


  #HEALTHCHECK
  get '/healthcheck', to: 'healthcheck#check_db'

  # Return 404 for any unmatched paths except those bound for Rails-provided actions
  match '*path', to: redirect('/404'), via: :all, constraints: lambda { |req|
    req.path !~ %r{^/rails}
  }
end
