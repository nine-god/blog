#= require rails-ujs
#= require turbolinks
#= require underscore
#= require backbone
#= require home
#= require articles
#= require abouts



AppView = Backbone.View.extend
  el: "body"

  initialize: ->
    switch($('body').data('controller-name'))
      when 'articles'
        window._articleView = new ArticleView()
      when 'home'
        window._homeView = new HomeView()
      when 'abouts'
        window._aboutView = new AboutView()
    

$(document).on "turbolinks:load", ->
  window._appView = new AppView()