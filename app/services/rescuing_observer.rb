# Delegates notifications to the decorated observer and rescues exceptions. Any
# exceptions raised will be sent to the error notifier.
class RescuingObserver
  pattr_initialize :observer, [:error_notifier!]

  def method_missing(name, *args, &block)
    observer.__send__(name, *args, &block)
    nil
  rescue StandardError => error
    error_notifier.notify(error)
  end

  private

  def respond_to_missing?(*args)
    observer.respond_to?(*args)
  end
end
