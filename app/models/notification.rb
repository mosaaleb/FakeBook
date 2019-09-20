# frozen_string_literal: true

class Notification < ApplicationRecord
  # Associations
  belongs_to :notifiable, polymorphic: true
  belongs_to :recipient, class_name: :User
  belongs_to :actor, class_name: :User

  # Validations
  validates :action, presence: true
end
