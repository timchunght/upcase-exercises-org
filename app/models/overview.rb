# Facade to encapsulate data for exercise overview and instructions page.
class Overview
  pattr_initialize [
    :channel!,
    :exercise!,
    :participation!,
    :progress!,
    :revision!,
    :solutions!,
    :status!,
    :user!
  ]
  attr_reader :exercise, :progress, :solutions, :status
  delegate :name, to: :channel, prefix: true
  delegate :title, to: :exercise
  delegate :clone, :unpushed?, to: :participation
  delegate :has_pending_public_keys?, :username?, to: :user

  def files
    revision.fmap(&:files).unwrap_or([])
  end

  def has_public_key?
    user.public_keys.any?
  end
end
