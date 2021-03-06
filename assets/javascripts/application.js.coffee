#= require jquery
#= require bootstrap

toggle = (element, nesting=0) ->
  switcher  = element.attr('data-switcher')
  selector  = element.attr('data-selector')
  group     = $("[data-group=#{switcher}]")
  inputs    = $("[data-input=#{switcher}]")

  if element.is(':checked')
    group.slideDown()
    inputs.filter('.default').hide()
    inputs.filter('.input').removeAttr('disabled').show()
  else
    group.slideUp()
    inputs.filter('.default').show()
    inputs.filter('.input').attr('disabled', 'disabled').hide()

  if nesting is 0 && element.is('[type=radio]')
    $("[data-selector=#{selector}]").each -> toggle $(this), nesting+1

filter = (element) ->
  category = element.attr('data-category')
  needle   = element.val()

  $(".category[data-category=#{category}]").each ->
    element = $(this)

    if needle.length == 0 || new RegExp('^'+needle, 'i').test(element.find('span').text())
      element.slideDown()
    else
      element.slideUp()

selectText = (element) ->
  if document.selection
    range = document.body.createTextRange()
    range.moveToElementText(element)
    range.select()
  else if window.getSelection
    range = document.createRange()
    range.selectNode(element)
    window.getSelection().addRange(range)

$ ->
  $('[data-switcher]').click -> toggle $(this)
  $('input[data-category]').keyup -> filter $(this)
  $('code').click -> selectText(this)

  $('#data').submit ->
    $('#id .help, #id .generated').hide()
    $('#id .spiner').show()

    $.post '/', $(this).serialize(), (result) ->
      $('#id .spiner').fadeOut ->
        $('#id .generated .id').text result

        $('#id .generated').fadeIn ->

          $('#help').slideDown ->
            location.href = "/#{result}"

          $('html, body').animate
            scrollTop: $('#help').offset().top

    false