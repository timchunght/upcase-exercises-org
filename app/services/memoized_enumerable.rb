class MemoizedEnumerable
  include Enumerable

  pattr_initialize :source

  def each(&block)
    memoized.each(&block)
  end

  private

  def memoized
    @memoized ||= source.to_a
  end
end
