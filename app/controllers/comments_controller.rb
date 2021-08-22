class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable ||= params[:commentable_type].classify.constantize.find(params[:commentable_id])
  end

  def publish_comment
    return unless @comment.valid?

    data = { comment: ApplicationController.render(
                        partial: 'comments/comment',
                        locals: { comment: @comment }
                      ),
            user_id: current_user.id,
            commentable_type: @comment.commentable_type,
            commentable_id: @comment.commentable_id }

    QuestionChannel.broadcast_to(@comment.find_question, data)
  end
end
