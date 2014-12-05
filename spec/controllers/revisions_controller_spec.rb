require "spec_helper"

describe RevisionsController do
  describe "#show" do
    context "as a subscriber with a solution" do
      it "renders the revision" do
        user = build_stubbed(:user)
        visit_revision_as(user, owner: user)

        expect(response).to render_template("revisions/show")
      end
    end

    context "as an admin without a solution" do
      it "renders the revision" do
        admin = build_stubbed(:admin)
        revision_owner = build_stubbed(:user)
        visit_revision_as(admin, owner: revision_owner)

        expect(response).to render_template("revisions/show")
      end
    end

    context "as a subscriber without a solution" do
      it "redirects to the exercise" do
        user = build_stubbed(:user)
        exercise = build_stubbed(:exercise)
        visit_revision_as(user, exercise: exercise)

        expect(response).to redirect_to(exercise_path(exercise))
      end
    end

    context "viewing non-existance solution" do
      it "raises ActiveRecord::RecordNotFound" do
        user = build_stubbed(:admin)

        expect { visit_revision_as(user, owner_solution: nil) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def visit_revision_as(visitor,
                        owner: build_stubbed(:user),
                        exercise: build_stubbed(:exercise),
                        owner_solution: build_stubbed(:solution))
    sign_in_as visitor

    allow(Exercise).to receive(:find).and_return(exercise)
    allow(User).to receive(:find).and_return(owner)

    revision = build_stubbed(:revision)
    allow(Revision).to receive(:find_by_number).and_return(revision)

    if visitor == owner
      submitted_solution = owner_solution
    else
      submitted_solution = nil
    end

    visitor_participation = participation_factory(visitor, exercise)
    allow(visitor_participation).
      to receive(:solution).and_return(submitted_solution.wrapped)

    owner_participation = participation_factory(owner, exercise)
    allow(owner_participation).
      to receive(:solution).and_return(owner_solution.wrapped)

    stub_factory_instance(
      :review_factory,
      exercise: exercise,
      viewed_solution: owner_solution,
      submitted_solution: submitted_solution.wrapped,
      reviewer: visitor,
      revision: revision
    )

    show(exercise, owner)
  end

  def participation_factory(user, exercise)
    stub_factory_instance(
      :participation_factory,
      exercise: exercise,
      user: user
    )
  end

  def show(exercise, user)
    get :show,
      exercise_id: exercise.to_param,
      solution_id: user.to_param,
      id: 1
  end
end
