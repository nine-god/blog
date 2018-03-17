#= require rails-ujs
#= require turbolinks
#= require underscore
#= require backbone
#= require home
#= require articles
#= require abouts



AppView = Backbone.View.extend
  el: "body"

  events:
    "click .btn-move-page": "scrollPage"

  initialize: ->
    switch($('body').data('controller-name'))
      when 'articles'
        window._articleView = new ArticleView()
      when 'home'
        window._homeView = new HomeView()
      when 'abouts'
        window._aboutView = new AboutView()
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