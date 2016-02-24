class User < ActiveRecord::Base
	enum role: [:admin, :member]

  devise :database_authenticatable, :registerable, :validatable

  # Overrides devise active_for_authentication to allow only admins to sign in
  def active_for_authentication?
    super and self.admin?
  end
end
