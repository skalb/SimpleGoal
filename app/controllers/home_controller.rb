class HomeController < ApplicationController
  def index
  	@goals = Goal.all
  end
end
