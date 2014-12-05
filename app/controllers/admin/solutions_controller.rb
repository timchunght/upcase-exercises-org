class Admin::SolutionsController < Admin::BaseController
  def index
    @solutions = dependencies[:unreviewed_solutions]
  end
end
