class Api::SolutionsController < Api::BaseController
  def index
    @solutions = dependencies[:latest_solutions]
  end
end
