class Device < ApplicationRecord
  has_many :reports
  has_many :heartbeats
  validates :phone_number, phone: { possible: true }
  validates :carrier, presence: true
end
