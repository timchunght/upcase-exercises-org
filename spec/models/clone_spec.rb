require 'spec_helper'

describe Clone do
  let(:subject) { build_stubbed(:clone) }

  it { should belong_to(:exercise) }
  it { should belong_to(:user) }
  it { should have_many(:revisions).dependent(:destroy) }
  it { should have_one(:solution).dependent(:destroy) }

  it 'enforces the Git SHA format' do
    should allow_value('abcdef1234567890abcdef1234567890abcdef12').
      for(:parent_sha).
        strict
    should_not allow_value('bad characters aaaaaaaaaaaaaaaaaaaaaaaaa').
      for(:parent_sha).
        strict
    should_not allow_value('a' * 39).
      for(:parent_sha).
        strict
    should_not allow_value('a' * 41).
      for(:parent_sha).
        strict
    should_not allow_value(nil).
      for(:parent_sha).
        strict
  end

  context "with pending clone" do
    let(:subject) { build_stubbed(:clone, :pending) }
    it { should allow_value(nil).for(:parent_sha).strict }
  end

  describe "#solution" do
    it "wraps its association" do
      solution = build_stubbed(:solution)
      clone = build_stubbed(:clone, solution: solution)

      result = clone.solution

      expect(result).to eq(solution.wrapped)
    end
  end

  describe '#title' do
    it 'delegates to its exercise' do
      exercise = build_stubbed(:exercise)
      clone = build_stubbed(:clone, exercise: exercise)

      expect(clone.title).to eq(exercise.title)
    end
  end

  describe '#username' do
    it 'delegates to its user' do
      user = build_stubbed(:user, username: 'username')
      clone = build_stubbed(:clone, user: user)

      expect(clone.username).to eq('username')
    end
  end

  describe '#create_revision!' do
    it 'creates a new revision with the given attributes' do
      revision = double('revisions.create!')
      solution = build_stubbed(:solution)
      clone = build_stubbed(:clone, solution: solution)
      allow(clone.revisions).
        to receive(:create!).
        with(diff: 'example', solution: solution).
        and_return(revision)

      result = clone.create_revision!(diff: 'example')

      expect(result).to eq(revision)
    end
  end

  describe '#create_solution!' do
    it 'creates a solution with the latest revision' do
      revision = double('revisions.latest')
      solution = double('Solution.create!')
      clone = build_stubbed(:clone)
      allow(clone.revisions).
        to receive(:latest).
        and_return(revision)
      allow(Solution).
        to receive(:create!).
        with(clone: clone).
        and_return(solution)
      allow(revision).to receive(:update_attributes!)

      result = clone.create_solution!

      expect(result).to eq(solution)
      expect(revision).to have_received(:update_attributes!).
        with(solution: solution)
    end
  end

  describe "#latest_revision" do
    it "returns the most recently created revision for this clone" do
      revision = double("revisions.latest")
      clone = build_stubbed(:clone)
      allow(clone.revisions).to receive(:latest).and_return(revision)

      result = clone.latest_revision

      expect(result).to eq(revision.wrapped)
    end
  end
end
