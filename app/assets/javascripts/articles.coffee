window.ArticleView = Backbone.View.extend
  el: "body"

  initialize: () ->
    $('#nav_articles').addClass("active")
    @init_button_goto_url()

  init_button_goto_url: () ->
    $("#button_go_url").click ->
      url = $("#button_go_url").attr('url')
      limit = $("#button_go_url").attr('limit')
      offset = ($('#page_num').val()-1)*limit
      window.location.href=url+"?"+"offset="+offset+"&&"+ "limit="+limit;
