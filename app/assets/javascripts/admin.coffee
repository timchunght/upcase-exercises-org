$ ->
  $(".editor#summary, .editor#intro, .editor#instructions").each ->
    previewer = $(".preview##{$(@).prop("id")}")

    $("textarea", @).crevasse
      previewer: previewer
