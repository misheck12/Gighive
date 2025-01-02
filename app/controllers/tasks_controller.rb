class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :changes, :accept, :submit_changes]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
    @categories = Category.all
    # Fetch categories for the dropdown
  end

  # Remove the get_subcategories action as it will be handled by CategoriesController
  # def get_subcategories
  #   category = Category.find(params[:category_id])
  #   subcategories = category.subcategories
  #   render json: { subcategories: subcategories }
  # end

  def create
    @task = Task.new(task_params)
    @task.client = current_user  # Set the client to the current user

    # Validate budget against the subcategory's minimum price
    if @task.budget < @task.get_minimum_price_for_subcategory(@task.subcategory)
      flash.now[:alert] = "Budget must be at least #{@task.get_minimum_price_for_subcategory(@task.subcategory)} ZMK for the selected subcategory."
      render :new and return
    end

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    # Ensure the budget is above the minimum price when editing
    if @task.budget < @task.get_minimum_price_for_subcategory(@task.subcategory)
      flash.now[:alert] = "Budget must be at least #{@task.get_minimum_price_for_subcategory(@task.subcategory)} ZMK for the selected subcategory."
      render :edit and return
    end

    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      @categories = Category.all
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
    if current_user == @task.freelancer
      if params[:revised_file].present?
        @task.revised_file.attach(params[:revised_file])
        @task.update(status: 'completed') # Update the task status after submitting changes

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

  def task_params
    params.require(:task).permit(:title, :description, :budget, :deadline, :category_id, :subcategory_id, :status, :completed_file, :attachment, :revised_file, :complexity, :time_commitment, :urgency, :revisions)
  end
end