require "spec_helper"

describe "api/solutions/index.rss.builder" do
  it "renders an RSS item for each solution" do
    @solutions = [
      stub_solution(title: "A", username: "1", created_at: 1.day.ago),
      stub_solution(title: "B", username: "2", created_at: 2.days.ago),
      stub_solution(title: "C", username: "3", created_at: 3.days.ago)
    ]

    render template: "api/solutions/index"

    expect_solution(
      index: 1,
      title: "Solution to A by 1",
      pub_date: 1.day.ago.to_s(:rfc822),
      link: exercise_solution_url("A", "1"),
      guid: exercise_solution_url("A", "1")
    )
    expect_solution(
      index: 2,
      title: "Solution to B by 2",
      pub_date: 2.days.ago.to_s(:rfc822),
      link: exercise_solution_url("B", "2"),
      guid: exercise_solution_url("B", "2")
    )
    expect_solution(
      index: 3,
      title: "Solution to C by 3",
      pub_date: 3.days.ago.to_s(:rfc822),
      link: exercise_solution_url("C", "3"),
      guid: exercise_solution_url("C", "3")
    )
  end

  def stub_solution(title:, username:, created_at:)
    double(
      "solution",
      title: title,
      username: username,
      created_at: created_at,
      exercise: double("exercise", to_param: title),
      user: double("user", to_param: username)
    )
  end

  def expect_solution(index:, title:, pub_date:, link:, guid:)
    expect(find("//item[#{index}]/title")).to eq(title)
    expect(find("//item[#{index}]/pubDate")).to eq(pub_date)
    expect(find("//item[#{index}]/link")).to eq(link)
    expect(find("//item[#{index}]/guid")).to eq(guid)
  end

  def find(xpath)
    if node = document.at(xpath)
      node.text
    else
      raise "No element at #{xpath}"
    end
  end

  let(:document) { Nokogiri::XML.parse(rendered) }

  around do |example|
    Timecop.freeze(Time.now) { example.run }
  end
end
