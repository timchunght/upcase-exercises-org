# Facade which composes facades for the review page.
class Review
  pattr_initialize([ :exercise!, :feedback!, :progress!, :solutions!, :status!])
  attr_reader :exercise, :feedback, :progress, :solutions, :status
end
