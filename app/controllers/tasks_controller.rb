class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :changes, :accept, :submit_changes]
  before_action :load_categories, only: [:new, :edit, :create, :update]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.client = current_user  # Set the client to the current user

    # Calculate the budget before saving
    @task.budget = calculate_budget(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    # Calculate the budget before updating
    updated_params = task_params.merge(budget: calculate_budget(task_params))

    if @task.update(updated_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  def accept
    if current_user.freelancer? && @task.open?
      @task.update(freelancer: current_user, status: :in_progress)
      redirect_to @task, notice: 'Task has been accepted!'
    else
      redirect_to @task, alert: 'You cannot accept this task!'
    end
  end

  def complete
    if @task.update(completed_file: params[:completed_file], status: "completed")
      redirect_to @task, notice: 'Task was successfully completed.'
    else
      render :show, alert: 'Unable to complete task.'
    end
  end

  def changes
    if current_user == @task.client && @task.completed?
      @task.update(status: 'changes_requested')
      redirect_to @task, notice: 'Change request has been sent to the freelancer.'
    else
      redirect_to @task, alert: 'You are not authorized to request changes for this task.'
    end
  end

  def submit_changes
    if current_user == @task.freelancer # Corrected: Use @task.freelancer instead of @task.freelancera
      if params[:revised_file].present?
        @task.revised_file.attach(params[:revised_file])
        @task.update(status: 'completed') # Update the task status after submitting changes
        @task.send_changes_submitted_notification

        redirect_to @task, notice: 'Your changes have been submitted successfully.'
      else
        redirect_to @task, alert: 'You must attach a file to submit changes.'
      end
    else
      redirect_to @task, alert: 'You are not authorized to perform this action.'
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def load_categories
    @categories = Category.all
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :budget,
      :deadline,
      :category_id,
      :subcategory_id,
      :status,
      :completed_file,
      :attachment,
      :revised_file,
      :complexity,
      :time_commitment,
      :urgency,
      :revisions
    )
  end
  
  def calculate_budget(params)
    revisions = params[:revisions].to_i > 0 ? params[:revisions].to_i : 1
    base_budget = Subcategory.find_by(id: params[:subcategory_id])&.minimum_price || 0
    complexity_multiplier = { 'Low' => 1.0, 'Medium' => 1.2, 'High' => 1.5 }[params[:complexity]] || 1.0
    urgency_multiplier = { 'Low' => 1.0, 'Normal' => 1.1, 'High' => 1.3 }[params[:urgency]] || 1.0
    revision_cost = 100 # You might want to make this a constant or configurable
    extra_revisions = [revisions - 1, 0].max # Ensure it's not negative

    total_budget = (base_budget * complexity_multiplier * urgency_multiplier) + (extra_revisions * revision_cost)
    total_budget.to_f
  end
end