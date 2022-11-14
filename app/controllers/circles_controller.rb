class CirclesController < ApplicationController
  def new
    @circle = Circle.new
    @users = current_user.friends
    @user_names = @users.pluck(:first_name)
    @colors = %w[#33a8c7 #52e3e1 #a0e426 #fdf148 #ffab00 #f77976 #f050ae #d883ff #9336fd]
  end

  def create
    @circle = Circle.new(circle_params)
    if @circle.save
      @circle.users << current_user
      params[:circle]["user_ids"].each do |friend|
        @circle.users << User.find_by(first_name: friend) if friend != ""
      end
      redirect_to @circle, notice: 'New Circle created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @circle = Circle.find(params[:id])
    @circle_events = CircleEvent.where(@circle_id)
    @circle_message = CircleMessage.new
  end

  def destroy
    @circle = Circle.find(params[:id])
    if current_user == @circle.user
      @circle.destroy
    end

    redirect_to root_path
  end

  private

  def circle_params
    params.require(:circle).permit(:name, :description, :photo, :private, :border_color)
  end
end
