class Job < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  store_accessor :projection, :state
end
