module Gitolite
  # Yields source repositories for each exercise in the collection.
  class SourceCollection
    include Enumerable

    pattr_initialize :exercises, :repository_finder

    def each(&block)
      sources.each(&block)
    end

    private

    def sources
      exercises.map do |exercise|
        repository_finder.find_source(exercise)
      end
    end
  end
end
