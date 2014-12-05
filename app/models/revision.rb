class Revision < ActiveRecord::Base
  belongs_to :clone
  belongs_to :solution
  has_one :exercise, through: :solution
  has_one :user, through: :solution

  validates :diff, presence: true, length: { maximum: 10.megabytes }

  def self.latest
    order(created_at: :desc).first
  end

  def latest?
    self == solution.latest_revision
  end

  def self.find_by_number(solution, number)
    solution.revisions.order(:created_at).at(number.to_i - 1)
  end
end
