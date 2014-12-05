require 'spec_helper'

describe Gitolite::SourceCollection do
  it 'is enumerable' do
    source_collection =
      Gitolite::SourceCollection.new([], double('repository_finder'))

    expect(source_collection).to be_a(Enumerable)
  end

  describe '#each' do
    it 'yields a source repository for each exercise' do
      exercises = [double('exercise'), double('exercise')]
      repository_finder = double('repository_finder')
      sources = exercises.map do |exercise|
        double('source').tap do |source|
          allow(repository_finder).
            to receive(:find_source).
            with(exercise).
            and_return(source)
        end
      end
      result = []
      source_collection =
        Gitolite::SourceCollection.new(exercises, repository_finder)

      source_collection.each do |source|
        result << source
      end

      expect(result).to eq(sources)
    end
  end
end
