class VotesController < GroupBaseController
  belongs_to :motion
  # before_filter :ensure_group_member
  # belongs_to :motion

  # def begin_of_association_chain
  #   @motion
  #
  def new
    @motion = Motion.find(params[:motion_id])
    @vote = Vote.new
    @vote.position = params[:position]
  end

  def destroy
    resource
    if @motion.voting?
      destroy! { @motion.discussion }
    else
      flash[:error] = "The proposal has closed. You can no longer modify your posiiton."
      redirect_to @motion.discussion
    end
  end

  def create
    @motion = Motion.find(params[:motion_id])
    if @motion.voting?
      @vote = Vote.new(params[:vote])
      @vote.motion = @motion
      @vote.user = current_user
      if @vote.save
        flash[:success] = "Position submitted"
      else
        flash[:warning] = "Your position could not be submitted"
      end
      redirect_to @motion
    else
      flash[:error] = "This proposal has closed. You can no longer decide on it."
      redirect_to @motion
    end
  end

  def update
    @motion = Motion.find(params[:motion_id])
    if @motion.voting?
      params[:vote].delete(:id)
      @vote = Vote.new(params[:vote])
      @vote.motion = @motion
      @vote.user = current_user
      if @vote.save
        flash[:success] = "Vote updated."
      else
        flash[:error] = "Could not update vote."
      end
    else
      flash[:error] = "Can only vote in voting phase"
    end
    redirect_to @motion.discussion
  end

  private

    def group
      group = Motion.find(params[:motion_id]).group
    end
end
