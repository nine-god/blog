class HomeController < ApplicationController
  def show
  end

  def about
  	@users = User.all
  end
end
