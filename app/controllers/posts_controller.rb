class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :load_facebook_client_side_config, :only => [:show]

  def index
    @posts = Post.order("created_at DESC")
  end

  def show
    @post = Post.find_by_id(params[:id])
    @comments = @post.comments.order("created_at DESC")

    @comment = @post.comments.build
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to posts_path, :notice => "Your post was edited succesfully"
    else
      flash[:error] = "There were some errors editing your post"
      render action: "edit"
    end    
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])

    @post.user = current_user

    if @post.save
      redirect_to posts_path, :notice => "Your post was created succesfully"
    else
      flash[:error] = "There were some errors creating your post"
      render action: "new"
    end    
  end
end
