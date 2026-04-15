# frozen_string_literal: true

class Diver < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  enum :certification_level, {
    open_water: 0,
    advanced: 1,
    rescue: 2,
    divemaster: 3,
    instructor: 4
  }, validate: true

  enum :privacy, {
    public: 0,
    members_only: 1,
    private: 2
  }, prefix: :profile, validate: true

  enum :provider, {
    google: 0,
    email: 1
  }, validate: true

  has_one_attached :avatar

  has_many :registrations, dependent: :destroy
  has_many :interests, dependent: :destroy

  validates :name, presence: true
  validates :dive_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  def self.from_google_oauth2(auth)
    return new.tap { |d| d.errors.add(:base, :invalid) } if auth.blank?

    email = auth.info.email&.strip&.downcase
    return new.tap { |d| d.errors.add(:email, :blank) } if email.blank?

    diver = find_by(email: email)
    if diver
      assign_google_identity!(diver, auth)
      diver
    else
      create_from_google!(auth, email)
    end
  end

  def self.assign_google_identity!(diver, auth)
    diver.uid = auth.uid
    diver.provider = :google
    diver.name = diver.name.presence || auth.info.name.to_s.strip.presence || diver.email.split("@").first
    diver.save(validate: false)
    diver.reload
  end
  private_class_method :assign_google_identity!

  def self.create_from_google!(auth, email)
    password = Devise.friendly_token[0, 32]
    create!(
      email: email,
      name: auth.info.name.to_s.strip.presence || email.split("@").first,
      provider: :google,
      uid: auth.uid,
      password: password,
      password_confirmation: password
    )
  rescue ActiveRecord::RecordInvalid => e
    e.record
  end
  private_class_method :create_from_google!

  def password_required?
    return false if google?

    super
  end
end
