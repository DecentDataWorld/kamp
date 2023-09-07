class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :read, Organization
    can :read, Collection
    can :read, Resource
    can :log_event, Resource

    if user.has_role? :member
      if user.has_approved_org
        can :add, Organization
        can :edit, Organization
        can :update, Organization
        can :add, Collection
        can :edit, Collection
        can :update, Collection
        can :add, Resource
        can :edit, Resource
        can :update, Resource
      end
    end

    if user.has_role? "moderator"
      can :add, Organization
      can :edit, Organization
      can :update, Organization
      can :add, Collection
      can :edit, Collection
      can :update, Collection
      can :destroy, Collection
      can :moderate, Collection
      can :approve, Collection
      can :add, Resource
      can :edit, Resource
      can :update, Resource
      can :destroy, Resource
      can :moderate, Resource
      can :approve, Resource
      can :add_newsletter_resource, Resource
      can :add_newsletter_collection, Collection
      #can :access, :ckeditor
    end

    if user.has_role? :admin
      can :manage, :all

      can :manage, Activity
      can :manage, Banner
      can :manage, Batch

      can :manage, Category

      can :approve, Collection
      can :moderate, Collection

      can :manage, Organization
      can :approve, Organization

      can :manage, License

      can :manage, Resource
      can :moderate, Resource

      can :manage, User
      can :index, User

      can :access, :rails_admin       # only allow admin users to access Rails Admin

      can :add_newsletter_resource, Resource
      can :add_newsletter_collection, Collection
      #can :access, :ckeditor
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
