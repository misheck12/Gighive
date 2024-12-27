# filepath: /app/services/zynle_payment_service.rb
require 'net/http'
require 'uri'
require 'json'

class ZynlePaymentService
  SANDBOX_URL = 'https://sandbox.zynlepay.com/zynlepay/jsonapi'
  PRODUCTION_URL = 'https://api.zynlepay.com/zynlepay/jsonapi'
  COST_PER_PAGE = 30

  def initialize(api_key:, api_id:, service_id:, merchant_id:, channel:, mode: :sandbox)
    @api_key = api_key
    @api_id = api_id
    @service_id = service_id
    @merchant_id = merchant_id
    @channel = channel
    @base_url = mode == :production ? PRODUCTION_URL : SANDBOX_URL
  end

  def momo_deposit(sender_id:, reference_no:, amount:)
    method = 'MomoDeposit'
    request_id = SecureRandom.uuid
    receiver_id = 'receiver_id_example' # Replace with actual receiver ID

    payload = {
      auth: {
        api_id: @api_id,
        service_id: @service_id,
        merchant_id: @merchant_id,
        api_key: @api_key,
        channel: @channel
      },
      data: {
        method: 'runPayToEwallet',
        request_id: request_id,
        receiver_id: receiver_id,
        reference_no: reference_no,
        amount: amount
      },
      userdata: {
        udf1: 'user_defined_field'
      }
    }

    post_request(method, payload)
  end

  def momo_withdraw(receiver_id:, reference_no:, amount:)
    method = 'MomoWithdraw'
    request_id = SecureRandom.uuid
    sender_id = 'sender_id_example' # Replace with actual sender ID

    payload = {
      auth: {
        api_id: @api_id,
        service_id: @service_id,
        merchant_id: @merchant_id,
        api_key: @api_key,
        channel: @channel
      },
      data: {
        method: 'runWithdrawToEwallet',
        request_id: request_id,
        sender_id: sender_id,
        reference_no: reference_no,
        amount: amount
      },
      userdata: {
        udf1: 'user_defined_field'
      }
    }

    post_request(method, payload)
  end

  private

  def post_request(method, payload)
    uri = URI.parse(@base_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    request = Net::HTTP::Post.new(uri.path, {
      'Content-Type' => 'application/json',
      'Accept' => '*/*'
    })

    request.body = payload.to_json

    response = http.request(request)
    JSON.parse(response.body)
  rescue StandardError => e
    { 'response' => { 'response_code' => '500', 'response_description' => e.message } }
  end
end