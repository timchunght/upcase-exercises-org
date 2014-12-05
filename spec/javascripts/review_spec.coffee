#= require application
#= require sinon
#= require sinon-chai
#= require chai-jquery

describe "Review", ->
  beforeEach ->
    sinon.spy(window, "prettyPrint")

  afterEach ->
    prettyPrint.restore()

  body = (html) ->
    $("body").html(html).find("[data-role=review]")

  commentsTemplate = """
    <div style="display: none">
      <ol data-role="inline-comments">
        <li data-role="comment-form" style="display: none">
          <form>
            <input type="hidden" name="comment[location]" />
            <textarea name="comment[body]"></textarea>
          </form>
        </li>
        <li data-role="form-toggle">
          <button>Add Comment</button>
        </li>
      </ol>
    </div>
  """

  showCommentsTemplate = """
    <div data-role="show-comments">
      <a href="#">0</a>
    </div>
  """

  templates = """
    <script type="text/html" data-template="inline-comments">
      #{commentsTemplate}
    </script>
    <script type="text/html" data-template="show-comments">
      #{showCommentsTemplate}
    </script>
    <div data-role="make-comment">
      <a href="#"></a>
    </div>
    <div data-role="top-level-comments">
      <ol>
        <li data-role="comment-form">
          <form>
            <textarea name="comment[body]"></textarea>
          </form>
        </li>
      </ol>
    </div>
  """

  makeTemplate = (file) ->
    reviewElement = $("<div/>").attr("data-role": "review")
    reviewElement.append buildFileMarkup(file)
    reviewElement.append(templates)
    body reviewElement[0].outerHTML

  buildFileMarkup = (file) ->
    locationTemplate = "#{file.location || '?'}"
    fileElement = $("<div/>").attr
      "data-role": "file"
      "data-location": locationTemplate
    fileElement.append $("<span/>").
      attr(class: "filename").
      text(file.filename || "testing.rb")

    $.each file.lines, (index, line) ->
      lineNumber = index + 1
      location = locationTemplate.replace("?", lineNumber)
      lineElement = buildLineMarkup(line)
      fileElement.append lineElement
      if line.comments?
        $(showCommentsTemplate).prependTo(lineElement)
        fileElement.append buildCommentsMarkup(location, line.comments)

    fileElement

  buildLineMarkup = (line) ->
    pre = $("<pre/>").text(line.text)
    $("<div/>").attr("data-role": "line").append(pre)

  buildCommentsMarkup = (location, comments) ->
    commentsElement = $(commentsTemplate)
    commentsElement.attr("data-comments-for": location)
    for comment in comments
      commentElement =
        $('<li/>').attr("data-role": "comment").text(comment)
      commentsElement.
        find("[data-role=comment-form]").
        before(commentElement)
    commentsElement

  inlineCommentForm = ->
    $("[data-role=inline-comments] form")

  commentsForLocation = (location) ->
    $("[data-role=line] + [data-comments-for='#{location}']")

  mouseOverLine = (text) ->
    line =
      if text?
        $("pre:contains('#{text}')")
      else
        $("pre").eq(0)
    expect(line.length).to.eq(1)
    line.mouseover()

  mouseOutLine = ->
    $("pre").mouseout()

  clickInlineCommentIcon = ->
    $("[data-role=make-comment] a").click()

  clickShowCommentsIcon = ->
    commentsIcon().click()

  commentsIcon = ->
    $("[data-role=show-comments] a")

  openCommentForm = ->
    $("[data-role=form-toggle] button:visible").click()

  expectToAddInlineCommentTo = (data) ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        $.extend { text: "Line" }, data
      ]

    new Review(template)
    mouseOverLine()
    clickInlineCommentIcon()
    template.find("textarea").val("New comment")

    inlineCommentForm().trigger(
      "ajax:success",
      """
        <li data-role="comment">New comment</li>
      """
    )

    expect(template.find("textarea")).to.have.value("")
    expect(inlineCommentForm()).to.be.hidden
    expect(commentsForLocation("123:file:1").text()).
      to.include("New comment")
    expect(commentsIcon().text()).to.eq(data.indicator)

  it "highlights code blocks", ->
    template = makeTemplate lines: [{ text: "one" }, { text: "two" }]

    new Review(template)

    expect(template.find("pre")).to.have.class("prettyprint")
    expect(prettyPrint).to.have.been.called

  it "adds highlight language hint based on file extension", ->
    template = makeTemplate
      lines: [{ text: "one" }, { text: "two" }]
      filename: "testing.rb"

    new Review(template)

    expect(template.find("pre")).to.have.class("lang-rb")
    expect(prettyPrint).to.have.been.called

  it "does not add highlight language hint if file has no extension", ->
    template = makeTemplate
      lines: [{ text: "one" }, { text: "two" }]
      filename: "testing"

    new Review(template)

    expect(template.find("pre")).not.to.have.class("lang-")
    expect(prettyPrint).to.have.been.called

  it "displays an inline comment form for the first comment", ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        { text: "one" }
        { text: "two" }
        { text: "three" }
      ]

    new Review(template)
    focused = null
    $("body").on "focus", "*", (event) ->
      focused = event.target

    mouseOverLine("two")
    clickInlineCommentIcon()

    expect(template.find("input[name='comment[location]']")).
      to.have.value("123:file:2")
    expect(inlineCommentForm()).to.be.visible
    expect(focused).to.eq(template.find("textarea")[0])

  it "displays an inline comment form for the second comment", ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        { text: "one", comments: ["first"] }
      ]

    new Review(template)

    clickShowCommentsIcon()
    openCommentForm()

    expect(template.find("input[name='comment[location]']")).
      to.have.value("123:file:1")
    expect(inlineCommentForm()).to.be.visible
    expect(template.find("button")).to.be.hidden
    expect(inlineCommentForm().length).to.equal(1)

  it "toggles the inline comment form", ->
    template = makeTemplate lines: [{ text: "Line" }]

    new Review(template)
    mouseOverLine()
    clickInlineCommentIcon()

    clickInlineCommentIcon()
    expect(inlineCommentForm().length).to.equal(1)
    expect(inlineCommentForm()).to.be.hidden
    expect(template.find("button")).to.be.hidden

    clickInlineCommentIcon()
    expect(inlineCommentForm().length).to.equal(1)
    expect(inlineCommentForm()).to.be.visible
    expect(template.find("button")).to.be.hidden

  it "toggles the inline comments", ->
    template = makeTemplate
      location: "123:file:?"
      lines: [
        { text: "one" }
        { text: "two", comments: ["Hello"] }
        { text: "three" }
      ]

    new Review(template)
    clickShowCommentsIcon()

    clickShowCommentsIcon()
    expect(commentsForLocation("123:file:2")).to.be.hidden
    expect(inlineCommentForm().length).to.equal(1)
    expect(inlineCommentForm()).to.be.hidden
    expect(template.find("button")).to.be.hidden

    clickShowCommentsIcon()
    expect(commentsForLocation("123:file:2")).to.be.visible
    expect(inlineCommentForm().length).to.equal(1)
    expect(inlineCommentForm()).to.be.hidden
    expect(template.find("button")).to.be.visible

  it "only adds one hover target", ->
    template = makeTemplate lines: [{ text: "Line" }]

    new Review(template)

    mouseOverLine()
    mouseOutLine()
    mouseOverLine()

    expect(template.find('a').length).to.equal(1)

  it "adds the first inline comment", ->
    expectToAddInlineCommentTo indicator: "1"

  it "adds the second inline comment", ->
    expectToAddInlineCommentTo comments: ["first"], indicator: "2"

  it "adds a top-level comment", ->
    template = makeTemplate lines: []

    new Review(template)
    template.find("textarea").val("text")

    template.
      find("[data-role=top-level-comments] form").
      trigger("ajax:success", "<li>New comment</li>")

    topLevelComments = template.find("[data-role=top-level-comments]")
    commentText = topLevelComments.find("li").text()
    expect(commentText).to.include("New comment")
    commentBeforeForm =
      topLevelComments.
        find("li:contains('New comment') + [data-role=comment-form]").
        length
    expect(commentBeforeForm).to.eq(1)
    expect(topLevelComments.find("textarea")).to.have.value("")
