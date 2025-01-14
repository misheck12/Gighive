class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:new, :create]
  before_action :set_payment, only: [:accept, :reject, :show]

  def new
    @payment = Payment.new
    @budgets = Budget.all
  end

  def show
    @payment = Payment.find_by(id: params[:id])
    if @payment.nil?
      redirect_to root_path, alert: 'Payment not found'
    end
  end

  def create
    @payment = @task.build_payment(payment_params)  # Use build_payment for has_one association
    @payment.user = current_user
    @payment.client = @task.client # Ensure client is set correctly
    @payment.status = :pending  # Assuming the status enum includes pending

    if @payment.save
      redirect_to task_path(@task), notice: 'Payment was successfully submitted and is pending approval.'
    else
      @budgets = Budget.all
      render :new
    end
  end

  def accept
    if @payment.update(status: :approved)
      redirect_to dashboard_path, notice: 'Payment was successfully approved.'
    else
      redirect_to dashboard_path, alert: 'Payment could not be approved.'
    end
  end

  def reject
    if @payment.update(status: :rejected)
      redirect_to dashboard_path, notice: 'Payment was successfully rejected.'
    else
      redirect_to dashboard_path, alert: 'Payment could not be rejected.'
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_payment
    @payment = Payment.find_by(id: params[:id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :transaction_id, :payment_proof, :network, :budget_id)
  end
end