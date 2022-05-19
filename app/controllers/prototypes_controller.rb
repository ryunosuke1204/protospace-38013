class PrototypesController < ApplicationController
  before_action :authenticate_user!,except: [:index,:show,:edit,:new]
  before_action :move_to_index, except: [:index, :show]
  before_action :set_prototype, only: [:edit, :show]
  
  

  def index
    @prototype = Prototype.all
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
      @prototype = Prototype.new(prototype_params)
      if @prototype.save
        redirect_to action: :index
      else
        render :new
    end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    if @prototype.destroy
      redirect_to action: :index
    end
  end


  private
  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

end

