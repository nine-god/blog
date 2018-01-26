#= require rails-ujs
#= require turbolinks
#= require underscore
#= require backbone
#= require articles
#= require home

$(document).on "turbolinks:load", ->
  articles.init_article()
  home.init_show()




