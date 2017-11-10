class CommentsController < ApplicationController
  before_action :set_post

  def create
    final_params = {}
    final_params[:is_top_level] = params[:depth].to_i == 0
    final_params[:body] = comment_params[:body]
  	comment = @post.comments.create! final_params
  	if params['depth'].to_i != 0 then
  	  parent = Comment.find(params[:parent_id].to_i)
  	  if not parent.children then
  	    parent.children = ''
  	  end
  	  parent.children = parent.children + ', ' + comment.id.to_s
  	  parent.save
  	end
    CommentsMailer.submitted(comment).deliver_later
    CommentsChannel.broadcast(comment)
  	redirect_to @post
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
  	params.require(:comment).permit(:body, :parent_id, :depth)
  end
end
