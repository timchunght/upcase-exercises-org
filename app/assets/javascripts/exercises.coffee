$('.exercise-demo').on 'click', 'li', (event) ->
  $(@).parent().find('.active').addClass('completed')
  $(@).addClass('active').siblings().removeClass('active')
  if $(@).is(':last-child')
    $(@).addClass('completed')
  false

$("a.fingerprints-toggle").on "click", ->
  $("pre.fingerprints").slideToggle()
  false
