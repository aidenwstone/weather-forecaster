class Location < ApplicationRecord
  belongs_to :user

  validate :has_address_or_ip

  def has_address_or_ip
    unless [ address, ip_address ].any?
      errors.add(:base, "Must include either 'address' or 'ip_address'")
    end
  end
end
