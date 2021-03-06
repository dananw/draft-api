class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
    # use Post.with_attached_photo.where(active: true) to avoid N+1 queries

    render jsonapi: @posts
  end

  # GET /posts/1
  def show
    render jsonapi: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render jsonapi: @post, status: :created, location: @post
    else
      respond_with_errors @post
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render jsonapi: @post
    else
      respond_with_errors @post
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      ActiveModelSerializers::Deserialization.jsonapi_parse!(params,
        only: [:title, :body, :tag_ids, :archived, :photo])
    end
end
