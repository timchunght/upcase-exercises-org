class CompositeObserver
  pattr_initialize :observers

  def method_missing(name, *args, &block)
    observers.each do |observer|
      observer.send(name, *args, &block)
    end
  end

  private

  def respond_to_missing?(*args)
    observers.any? { |observer| observer.respond_to?(*args) }
  end
end
