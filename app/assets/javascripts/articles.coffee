window.articles = 
  preview: (body) ->
    $("#preview").text "Loading..."
    $.post "/articles/preview",
      "body": body,
      (data) ->
        $("#preview").html data.body
      "json"

  init_article: ->
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
      articles.preview($('textarea').val())
      return false
    $("#button_go_url").click ->
      url = $("#button_go_url").attr('url')
      limit = $("#button_go_url").attr('limit')
      offset = ($('#page_num').val()-1)*limit
      window.location.href=url+"?"+"offset="+offset+"&&"+ "limit="+limit;
