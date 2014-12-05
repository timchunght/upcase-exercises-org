class Comment < ActiveRecord::Base
  TOP_LEVEL = 'top-level'.freeze

  belongs_to :solution, counter_cache: true
  belongs_to :user

  validates :text, presence: true

  delegate :subscribers, to: :solution

  def self.new_top_level
    new(location: TOP_LEVEL)
  end

  def solution_submitter
    solution.user
  end

  def exercise
    solution.exercise
  end

  def top_level?
    location == TOP_LEVEL
  end
end
