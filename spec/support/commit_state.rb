class CommitState
  attr_reader :added, :committed, :message, :pushed

  def initialize
    @added = nil
    @committed = nil
    @pushed = nil
    @message = nil
  end

  def add
    @added = Dir.glob('*')
  end

  def commit(message)
    @committed = @added
    @message = message
  end

  def push
    @pushed = @committed
  end
end
