class @Review
  constructor: (@element) ->
    @element.find("[data-role=file]").each (_, element) =>
      new File(this, $(element), @template)
    @hoverIcon = @element.find("[data-role=make-comment]")
    @prepareTopLevelComments()
    prettyPrint()

  prepareTopLevelComments: ->
    @topLevelComments = new TopLevelComments(
      this,
      @element.find("[data-role=top-level-comments]")
    )

  lineHovered: (line) ->
    @hoverIcon.remove()
    line.showMakeCommentIcon(@hoverIcon)

  makeCommentClicked: (line) =>
    line.toggleCommentForm()

  showCommentsClicked: (line) =>
    line.toggleComments()

  commentFormSubmitted: (container, result) =>
    container.addComment(result)
    container.closeCommentForm()

  template: (name) =>
    @element.find("[data-template='#{name}']").html()

class TopLevelComments
  constructor: (@review, @element) ->
    @element.
      find("form").
      on("ajax:success", @topLevelCommentSubmitted)

  topLevelCommentSubmitted: (event, result) =>
    @review.commentFormSubmitted(this, result)

  addComment: (html) ->
    @element.find("[data-role=comment-form]").before(html)

  closeCommentForm: ->
    @element.find("textarea").val("")

class File
  constructor: (@review, @element, @template) ->
    @extractFileType()
    @element.find("[data-role=line]").each (index, element) =>
      lineNumber = index + 1
      locationTemplate = @element.data("location")
      location = locationTemplate.replace("?", lineNumber)
      new Line(@review, $(element), location, @fileType, @template)

  extractFileType: ->
    filename = @element.find("span.filename").text()
    match = filename.match(/\.([^.]+)$/)

    if match
      @fileType = match[1]

class Line
  constructor: (@review, @element, @location, fileType, @template) ->
    @element.on "mouseenter", @mouseEnter
    @element.find("pre").addClass("prettyprint")

    if fileType
      @element.find("pre").addClass("lang-#{fileType}")

    @findComments()
    @findToggleIcon()

  mouseEnter: =>
    @review.lineHovered(this)

  showMakeCommentIcon: (icon) ->
    if @toggleIcon.length == 0
      icon.prependTo(@element)
      icon.on "click", @makeCommentClicked

  makeCommentClicked: (event) =>
    event.preventDefault()
    @review.makeCommentClicked(this)

  showCommentsClicked: (event) =>
    event.preventDefault()
    @review.showCommentsClicked(this)

  toggleCommentForm: () ->
    unless @comments?
      @renderComments()

    if @commentForm().is(":visible")
      @closeCommentForm()
    else
      @openCommentForm()

  closeCommentForm: ->
    @commentForm().find("textarea").val("")
    @commentForm().hide()
    if @hasComments()
      @formToggle().show()

  openCommentForm: ->
    unless @comments.is(":visible")
      @showComments()

    @commentForm().show()
    @formToggle().hide()
    @commentForm().find("textarea").focus()

  toggleComments: () ->
    if @comments.is(":visible")
      @hideComments()
    else
      @showComments()

  showComments: () ->
    @comments.show()

  hideComments: () ->
    @closeCommentForm()
    @comments.hide()

  commentForm: () ->
    @comments.find("[data-role=comment-form]")

  formToggle: () ->
    @comments.find("[data-role=form-toggle]")

  addComment: (html) ->
    @commentForm().before(html)
    @renderToggleIcon()

  renderToggleIcon: ->
    @toggleIcon.remove()
    toggleIcon = $(@template("show-comments"))
    toggleIcon.find("a").text(@commentsCount())
    toggleIcon.prependTo(@element)
    @findToggleIcon()

  commentsCount: ->
    @comments.find("[data-role=comment]").length

  prepareComments: ->
    @comments.find("form").on("ajax:success", @commentFormSubmitted)
    @comments.find("input[name='comment[location]']").val(@location)
    @formToggle().on("click", @makeCommentClicked)

  findComments: ->
    comments = $("[data-comments-for='#{@location}']")
    if comments.length > 0
      @comments = comments
      @prepareComments()

  findToggleIcon: ->
    @toggleIcon = @element.find("[data-role='show-comments']")
    @toggleIcon.on("click", @showCommentsClicked)

  renderComments: ->
    @comments = $(@template("inline-comments"))
    @comments.attr("data-comments-for": @location)
    @element.after(@comments)
    @prepareComments()

  hasComments: ->
    @comments.find("[data-role=comment]").length > 0

  commentFormSubmitted: (_, result) =>
    @review.commentFormSubmitted(this, result)
