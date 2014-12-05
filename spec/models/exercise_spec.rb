require 'spec_helper'

describe Exercise do
  it { should validate_presence_of(:instructions) }
  it { should validate_presence_of(:intro) }
  it { should validate_presence_of(:title) }

  it { should have_many(:clones).dependent(:destroy) }
  it { should have_many(:solutions).through(:clones) }
  it { should have_many(:comments).through(:solutions) }

  it 'validates uniqueness of title' do
    create(:exercise)
    should validate_uniqueness_of(:title)
  end

  describe '.alphabetical' do
    it 'returns exercises alphabetically by title' do
      create :exercise, title: 'def'
      create :exercise, title: 'abc'
      create :exercise, title: 'ghi'

      result = Exercise.alphabetical

      expect(result.pluck(:title)).to eq(%w(abc def ghi))
    end
  end

  describe '#has_comments_from?' do
    context 'when an exercise has comments from a given user' do
      it 'returns true' do
        exercise = create(:exercise)
        user = double('user')
        allow(exercise.comments).
          to receive(:where).
          with(user: user).
          and_return([double('comment')])

        result = exercise.has_comments_from?(user)

        expect(result).to be_truthy
      end
    end

    context 'when an exercise has no comments from a given user' do
      it 'returns false' do
        exercise = create(:exercise)
        user = double('user')
        allow(exercise.comments).
          to receive(:where).
          with(user: user).and_return([])

        result = exercise.has_comments_from?(user)

        expect(result).to be_falsey
      end
    end
  end

  context "#uuid" do
    it "sets a random uuid when an exercise is created" do
      exercise = create(:exercise)

      expect(exercise.uuid).to be_present
    end
  end

  describe '#has_solutions?' do
    context 'with a solution' do
      it 'returns true' do
        exercise = create(:exercise)
        clone = create(:clone, exercise: exercise)
        create(:solution, clone: clone)

        expect(exercise).to have_solutions
      end
    end

    context 'with no solutions' do
      it 'returns false' do
        exercise = build_stubbed(:exercise)

        expect(exercise).not_to have_solutions
      end
    end
  end

  describe '#slug' do
    it 'generates a slug based on the title' do
      exercise = create(:exercise, title: 'Example Title')

      expect(exercise.slug).to eq('example-title')
    end
  end

  describe '#to_param' do
    it 'uses its slug' do
      exercise = build_stubbed(:exercise, slug: 'a-slug')

      expect(exercise.to_param).to eq(exercise.slug)
    end

    it 'returns a findable value' do
      exercise = create(:exercise)

      expect(Exercise.find(exercise.to_param)).to eq(exercise)
    end
  end

  describe '#solvers' do
    it 'returns users which have submitted a solution to this exercise' do
      exercise = create(:exercise)
      other_exercise = create(:exercise)
      start exercise, username: 'started'
      solve exercise, username: 'solved_one'
      solve exercise, username: 'solved_two'
      solve other_exercise, username: 'solved_other'

      result = exercise.solvers.to_a

      expect(result.map(&:username)).to match_array(%w(solved_one solved_two))
    end

    it 'eager loads' do
      exercise = create(:exercise)
      expect { exercise.reload.solvers.to_a }.to eager_load { solve(exercise) }
    end

    def solve(exercise, user_attributes = {})
      clone = start(exercise, user_attributes)
      create(:solution, clone: clone)
    end

    def start(exercise, user_attributes = {})
      solver = create(:user, user_attributes)
      create(:clone, exercise: exercise, user: solver)
    end
  end
end
