require 'spec_helper'

describe PrioritizedSolutionQuery do
  it 'is enumerable' do
    expect(PrioritizedSolutionQuery.new(Solution.all)).to be_a(Enumerable)
  end

  context '#each' do
    it 'yields solutions with fewer comments, then older solutions' do
      create_solution 'three', comments_count: 1, created_at: 1.day.ago
      create_solution 'four', comments_count: 2, created_at: 1.day.ago
      create_solution 'one', comments_count: 0, created_at: 3.days.ago
      create_solution 'two', comments_count: 1, created_at: 2.days.ago
      query = PrioritizedSolutionQuery.new(Solution.all)

      result = iterate_solutions(query)

      expect(result).to eq(%w(one two three four))
    end
  end

  def create_solution(diff, attributes)
    create(:solution, attributes).tap do |solution|
      create(:revision, solution: solution, diff: diff)
    end
  end

  def iterate_solutions(enumerable)
    solutions = []
    enumerable.each { |yielded| solutions << yielded }
    solutions.map { |solution| solution.latest_revision.diff }
  end
end
