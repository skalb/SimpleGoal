class Goal < ActiveRecord::Base
  belongs_to :user

  has_many :targets
  has_many :entries
end
