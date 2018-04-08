#= require rails-ujs
#= require turbolinks
#= require underscore
#= require backbone
#= require home
#= require articles
#= require abouts
#= require users
#= require editor


AppView = Backbone.View.extend
  el: "body"

  events:
    "click .btn-move-page": "scrollPage"

  initialize: ->
    switch($('body').data('controller-name'))
      when 'articles'
        window._articleView = new ArticleView()
        @init_edit()
      when 'home'
        window._homeView = new HomeView()
      when 'abouts'
        window._aboutView = new AboutView()
        @init_edit()
      when 'users'
        window._userView = new UserView()
        @init_edit()
    @init_scroll()

  scrollPage: (e) ->
    target = $(e.currentTarget)
    moveType = target.data('type')
    opts =
      scrollTop: 0
    if moveType == 'bottom'
      opts.scrollTop = $('body').height()
    $("body, html").animate(opts, 300)
    return false

  preview: (body) ->
    $("#preview").text "Loading..."
    control_name = $('body').data('controller-name')
    $.post "/articles/preview",
      "body": body,
      (data) ->
        $("#preview").html data.body
      "json"

  init_edit: (e) ->
    self = @
    preview_box = $(document.createElement("div")).attr "id", "preview"
    preview_box.addClass("markdown form-control")
    $('textarea').after preview_box
    preview_box.hide()
    window._editor = new Editor()
    
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
      self.preview($('textarea').val())
      return false
        
  init_scroll: (e) ->
    window_height=$(window).height() #获取当前窗口高度
    body_height=$('body').height() #获取body标签高度
    height = body_height - window_height
    if $(window).scrollTop()==0
      $('.jump_top').addClass("hide")
    if $(window).scrollTop()==height
      $('.jump_bottom').addClass("hide")
    $(window).scroll ->
      scrollTop_value=$(window).scrollTop()
      if scrollTop_value>0 
        $('.jump_top').removeClass("hide")
      else
        $('.jump_top').addClass("hide")

      if scrollTop_value<height
        $('.jump_bottom').removeClass("hide")
      else
        $('.jump_bottom').addClass("hide")


$(document).on "turbolinks:load", ->
  window._appView = new AppView()