class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/#
  # GET /posts/#.json
  def show
    @post = Post.find(params[:id])
    paragraphs = @post.body.split('<paragraph>')
    @paragraphs = []
    for p in paragraphs do
      bolds = p.scan(/\<b\>[a-zA-Z0-9 \“\”\'\’\"\,\.\—]*\<b\>/)
      boldsFinal = []
      regulars = p.split(/\<b\>[a-zA-Z0-9 \“\”\'\’\"\,\.\— ]*\<b\>/)
      for bold in bolds do
        boldsFinal.push(bold[3..-4])
      end
      @paragraphs.push([regulars, boldsFinal])
    end
    
    allComments = Hash.new
    topLevelComments = []
    for comment in @post.comments do 
      allComments[comment.id] = comment
      if comment.is_top_level then
        topLevelComments.push(comment)
      end
    end 
    
    @allComments = [] # [[depth, comment, parent_id], ...]
    def addComment(comment, depth, parent_id, all_comments)
      @allComments.push([depth, comment, parent_id])
      if comment.children then
        for subCommentKey in comment.children.split(",").reverse do
          if subCommentKey != ''
            addComment(all_comments[subCommentKey.gsub(/\s+/, "").to_i], depth + 1, comment.id, all_comments)
          end
        end
      end
    end
    for comment in topLevelComments do
      addComment(comment, 0, -1, allComments)
    end
    

    
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :thumbnail, :body)
    end
end
