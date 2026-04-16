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

  after_create_commit :enqueue_welcome_email


  # Buzos con al menos una inscripción o interés en viajes/cursos de esta agencia.
  def self.for_agency(agency)
    reg_ids = filter_records_by_agency_programs(Registration.all, agency).distinct.pluck(:diver_id)
    int_ids = filter_records_by_agency_programs(Interest.all, agency).distinct.pluck(:diver_id)
    where(id: (reg_ids | int_ids).uniq)
  end

  def registrations_for_agency(agency)
    self.class.send(:filter_records_by_agency_programs, registrations, agency)
  end

  def interests_for_agency(agency)
    self.class.send(:filter_records_by_agency_programs, interests, agency)
  end

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

  def enqueue_welcome_email
    DiverMailer.welcome(self).deliver_later
  end

  # Compatibilidad con nomenclatura explícita (OAuth).
  alias provider_google? google?

  def self.filter_records_by_agency_programs(relation, agency)
    trip_ids = agency.dive_trip_ids
    course_ids = agency.course_ids
    branches = []
    branches << relation.where(program_type: "DiveTrip", program_id: trip_ids) if trip_ids.any?
    branches << relation.where(program_type: "Course", program_id: course_ids) if course_ids.any?
    return relation.none if branches.empty?

    branches.one? ? branches.first : branches.reduce { |acc, rel| acc.or(rel) }
  end
  private_class_method :filter_records_by_agency_programs
end
