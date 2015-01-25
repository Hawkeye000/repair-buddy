class CarPolicy < ApplicationPolicy

  def destroy?
    user == record.user
  end

  def show?
    user == record.user
  end

  def create?
    user == record.user
  end

end
