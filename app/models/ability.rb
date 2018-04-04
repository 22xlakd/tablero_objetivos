class Ability
  include CanCan::Ability

  def initialize(user)
    if user.respond_to?(:include_role?) && user.include_role?('admin')
      can :manage, :all
    else
      cannot [:save, :create], User
      can :read, User
      can [:display, :read, :tablero_objetivos], Variable do |variable|
        variable.registros.select { |r| r.user.codigo_sucursal == user.codigo_sucursal }.count > 0
      end

      can [:display, :read], Registro do |registro|
        registro.codigo_sucursal == user.codigo_sucursal.to_i
      end

      can [:display, :read], Objetivo do |objetivo|
        objetivo.user == user
      end
    end

    # Protect admin role
    cannot [:update, :destroy], Role, name: ['admin']

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
