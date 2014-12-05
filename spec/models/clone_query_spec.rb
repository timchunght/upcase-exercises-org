require "spec_helper"

describe CloneQuery do
  describe "#for_user" do
    context "with an existing clone" do
      it "wraps the clone" do
        user = double("user", id: 123)
        clone = double("clone")
        relation = double("relation")
        allow(relation).
          to receive(:find_by).
          with(user_id: user.id).
          and_return(clone)
        query = CloneQuery.new(relation)

        result = query.for_user(user)

        expect(result).to eq(clone.wrapped)
      end
    end

    context "without an existing clone" do
      it "returns blank" do
        user = create(:user)
        query = CloneQuery.new(Clone.all)

        result = query.for_user(user)

        expect(result).to be_blank
      end
    end
  end

  describe "#create!" do
    it "delegates to its relation" do
      expected = double("expected")
      arguments = double("arguments")
      relation = double("relation")
      allow(relation).to receive(:create!).and_return(expected)
      query = CloneQuery.new(relation)

      result = query.create!(arguments)

      expect(relation).to have_received(:create!).with(arguments)
      expect(result).to eq(expected)
    end
  end
end
