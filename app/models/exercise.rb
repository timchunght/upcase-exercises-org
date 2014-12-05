# Exercises are for improving skills.
class Exercise < ActiveRecord::Base
  extend FriendlyId

  has_many :clones, dependent: :destroy
  has_many :solutions, through: :clones
  has_many :comments, through: :solutions

  validates :instructions, presence: true
  validates :intro, presence: true
  validates :title, presence: true, uniqueness: true

  friendly_id :title, use: [:slugged, :finders]

  before_create :set_uuid

  def self.alphabetical
    order(:slug)
  end

  def has_solutions?
    solutions.any?
  end

  def solvers
    clones.includes(:user).joins(:solution).map(&:user)
  end

  def has_comments_from?(user)
    comments.where(user: user).present?
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
