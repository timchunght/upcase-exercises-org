require 'spec_helper'

describe ChronologicalQuery do
  it 'is enumerable' do
    query = ChronologicalQuery.new(Comment.all)

    expect(query).to be_a(Enumerable)
  end

  it "decorates its relation" do
    create = double("comments.create")
    comment_params = double("comment_params")
    comments = double("comments")
    allow(comments).to receive(:create).and_return(create)
    query = ChronologicalQuery.new(comments)

    result = query.create(comment_params)

    expect(result).to eq(create)
    expect(comments).
      to have_received(:create).with(comment_params)
  end

  describe '#each' do
    it 'yields items in ascending order' do
      create(:comment, created_at: 2.days.ago, text: 'middle')
      create(:comment, created_at: 1.day.ago, text: 'newest')
      create(:comment, created_at: 3.days.ago, text: 'oldest')
      result = []

      ChronologicalQuery.new(Comment.all).each { |yielded| result << yielded }

      expect(result.map(&:text)).to eq(%w(oldest middle newest))
    end
  end
end
