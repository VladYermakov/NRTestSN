class Ability
  include CanCan::Ability

  def initialize(user)
    can [:update, :delete], [Article, Comment] do |resource|
      resource.user_id == user.id
    end
  end
end
