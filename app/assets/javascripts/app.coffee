#= require rails-ujs
#= require turbolinks
#= require underscore
#= require backbone
#= require articles

$(document).on "turbolinks:load", ->
  init_article()

preview = (body) ->
  $("#preview").text "Loading..."
  $.post "/articles/preview",
    "body": body,
    (data) ->
      $("#preview").html data.body
    "json"

init_article = ->
  preview_box = $(document.createElement("div")).attr "id", "preview"
  preview_box.addClass("markdown form-control")
  $('textarea').after preview_box
  preview_box.hide()

  $(".edit a").click ->
    $(".preview").removeClass("active")
    $(this).parent().addClass("active")
    $(preview_box).hide()
    $('textarea').show()
    return false

  $(".preview a").click ->
    $(".edit").removeClass("active")
    $(this).parent().addClass("active")
    $(preview_box).show()
    $('textarea').hide()
    preview($('textarea').val())
    return false

