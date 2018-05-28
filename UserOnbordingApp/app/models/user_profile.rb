class UserProfile < ApplicationRecord
  belongs_to :user

  validates :dob, :building_number, :presence => true
  validates :first_name, :last_name, :presence => true, length: { in: 2..20 }
  validates :street_address, :presence => true, length: { in: 3..50 }
  validates :city, :state, :presence => true, length: { in: 2..20 }
  validates :zip_code, presence: true, numericality: { only_integer: true }, length: { in: 2..8 }
  validates :phone_number, presence: true, numericality: { only_integer: true }, length: { in: 10..15 } 
  
  has_attached_file :identity_photo, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :identity_photo, content_type: /\Aimage\/.*\Z/
  has_attached_file :user_photo, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :user_photo, content_type: /\Aimage\/.*\Z/
  validate :validate_age

  def self.for_select
    CS.countries.each do |value|
      [value]
    end
  end

  private

  def validate_age
      if dob.present? && dob > 18.years.ago
          errors.add(:dob, 'You should be over 18 years old.')
      end
  end
end
