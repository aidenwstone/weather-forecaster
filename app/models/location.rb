class Location < ApplicationRecord
  belongs_to :user

  validate :has_address_or_ip

  validates :latitude, numericality: { in: (-90..90) }, allow_nil: true

  validates :longitude, numericality: { in: (-180..180) }, allow_nil: true

  def has_address_or_ip
    if [ address, ip_address ].all?("")
      errors.add(:base, "Must include either 'address' or 'ip_address'")
    end
  end
end
