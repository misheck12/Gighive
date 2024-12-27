class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :changes, :accept, :submit_changes]

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

    # Calculate the required payment
    amount = @task.pages * ZynlePaymentService::COST_PER_PAGE

    # Initialize payment service
    payment_service = ZynlePaymentService.new(
      api_key: ENV['ZYNLE_API_KEY'],
      api_id: ENV['ZYNLE_API_ID'],
      service_id: ENV['ZYNLE_SERVICE_ID'],
      merchant_id: ENV['ZYNLE_MERCHANT_ID'],
      channel: ENV['ZYNLE_CHANNEL'],
      mode: :sandbox # Change to :production in production environment
    )

    # Generate a unique reference number
    reference_no = SecureRandom.uuid

    # Initiate payment
    response = payment_service.momo_deposit(
      sender_id: current_user.phone_number, # Ensure current_user has phone_number attribute
      reference_no: reference_no,
      amount: amount
    )

    # Check payment response
    if response['response']['response_code'] == '120'
      # Payment successful, assign payment details to the task
      @task.price = amount
      @task.reference_no = reference_no
      @task.transaction_id = response['response']['transaction_id'] || 'N/A' # Adjust based on actual response

      if @task.save
        UserMailer.task_notification(@task.client, @task).deliver_now
        redirect_to @task, notice: 'Task was successfully created and payment initiated.'
      else
        # Payment was successful but task creation failed
        redirect_to new_task_path, alert: 'Payment was successful, but there was an error creating the task.'
      end
    else
      # Payment failed
      redirect_to new_task_path, alert: "Payment failed: #{response['response']['response_description']}"
    end
  rescue StandardError => e
    redirect_to new_task_path, alert: "An error occurred during payment: #{e.message}"
  end

  def edit
  end

  def update
    if @task.update(task_params)
      UserMailer.task_status_update(@task.client, @task).deliver_now
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
      UserMailer.task_accepted(@task.client, @task).deliver_now
      redirect_to @task, notice: 'Task has been accepted!'
    else
      redirect_to @task, alert: 'You cannot accept this task!'
    end
  end

  def complete
    if @task.update(completed_file: params[:completed_file], status: "completed")
      UserMailer.task_completed(@task.client, @task).deliver_now
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
    # Ensure that only the assigned freelancer can submit changes
    if current_user == @task.freelancer
      if params[:revised_file].present?
        @task.revised_file.attach(params[:revised_file])
        @task.update(status: 'completed') # Update the task status as needed

        UserMailer.task_completed(@task.client, @task).deliver_now
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
    params.require(:task).permit(:title, :description, :pages, :price, :deadline, :category, :status, :client_id, :freelancer_id, :completed_file, :attachment, :revised_file, :reference_no, :transaction_id)
  end
end