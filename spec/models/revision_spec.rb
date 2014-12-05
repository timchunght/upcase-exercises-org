require 'spec_helper'

describe Revision do
  it { should belong_to :clone }
  it { should belong_to :solution }
  it { should have_one(:exercise).through(:solution) }
  it { should have_one(:user).through(:solution) }
  it { should validate_presence_of(:diff) }
  it { should ensure_length_of(:diff).is_at_most(10.megabytes) }

  describe '#latest' do
    it 'returns the most recently created revision' do
      create :revision, created_at: 2.day.ago, diff: 'middle'
      create :revision, created_at: 1.day.ago, diff: 'latest'
      create :revision, created_at: 3.day.ago, diff: 'oldest'

      result = Revision.latest

      expect(result.diff).to eq('latest')
    end
  end

  describe "#find_by_number" do
    it "returns the revision version matching the number and solution" do
      solution = create :solution
      middle_revision = create :revision, created_at: 2.day.ago
      latest_revision = create :revision, created_at: 1.day.ago
      oldest_revision = create :revision, created_at: 3.day.ago
      solution.revisions << [oldest_revision, middle_revision, latest_revision]

      result = Revision.find_by_number(solution, "2")

      expect(result.id).to eq middle_revision.id
    end
  end

  describe "#latest?" do
    context "when the revision is its solution latest revision" do
      it "returns true" do
        solution = create :solution
        latest_revision = create :revision, created_at: 1.day.ago
        oldest_revision = create :revision, created_at: 3.day.ago
        solution.revisions << [oldest_revision, latest_revision]

        expect(latest_revision.latest?).to be_truthy
      end
    end

    context "when the revision is not its solution latest revision" do
      it "returns false" do
        solution = create :solution
        latest_revision = create :revision, created_at: 1.day.ago
        oldest_revision = create :revision, created_at: 3.day.ago
        solution.revisions << [oldest_revision, latest_revision]

        expect(oldest_revision.latest?).to be_falsey
      end
    end
  end
end
