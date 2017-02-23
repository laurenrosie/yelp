class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]
  before_action :restaurant_owner, :except => [:index, :show, :new, :create]

  def restaurant_owner
    @restaurant = Restaurant.find(params[:id])
    puts @restaurant.inspect
    puts current_user.inspect
    @user = User.find(@restaurant.user_id)
    unless @user.id == current_user.id
     flash[:notice] = 'Access denied as you are not the owner of this Restaurant'
     redirect_to restaurants_path
    end
  end

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
    @user = User.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    @restaurant.user_id = current_user.id
  if @restaurant.save
    redirect_to restaurants_path
  else
    render 'new'
  end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)

    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    flash[:notice] = 'Restaurant deleted successfully'
    redirect_to'/restaurants'
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end


end
