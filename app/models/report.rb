class Report < ApplicationRecord
  belongs_to :device

  validates :message, presence: true
  validates :sender, presence: true
end
