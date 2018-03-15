window.HomeView = Backbone.View.extend
  el: "body"

  initialize: () ->
    $('#nav_home').addClass("active")