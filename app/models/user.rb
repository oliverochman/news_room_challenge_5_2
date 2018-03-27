class User < ApplicationRecord
  after_validation :reverse_geocode  # auto-fetch address
  after_initialize :set_default_role, if: :new_record?

  reverse_geocoded_by :latitude, :longitude
  enum role: [:visitor, :author]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  include DeviseTokenAuth::Concerns::User

  private

  def set_default_role
    self.role ||= :visitor
  end
end
