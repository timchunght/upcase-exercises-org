xml.instruct!
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Latest Solutions To Upcase Exercises"
    xml.description "Private Channel"
    xml.link(
      href: api_solutions_url(format: :rss),
      rel: "self",
      xmlns: "http://www.w3.org/2005/Atom"
    )
    xml.link admin_solutions_url

    @solutions.each do |solution|
      xml.item do
        xml.title "Solution to #{solution.title} by #{solution.username}"
        xml.pubDate solution.created_at.to_s(:rfc822)
        xml.link exercise_solution_url(solution.exercise, solution.user)
        xml.guid exercise_solution_url(solution.exercise, solution.user)
      end
    end
  end
end
