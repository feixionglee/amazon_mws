require 'builder'

class Amazon::BaseController < ApplicationController
  def get_conn
    conn = Faraday.new(:url => AWS_ENDPOINT) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def default_query
    { AWSAccessKeyId: AWS_ACCESS_KEY_ID,
      Merchant: AWS_MERCHANT_ID,
      SignatureMethod: "HmacSHA256",
      SignatureVersion: 2,
      # SubmittedFromDate: Date.today.iso8601+'T12:00:00Z',
      Timestamp: Time.now.utc.iso8601,
      Version: '2009-01-01' }
  end

  def build_query options={}
    if options.present?
      default_query.merge! options
    else
      default_query
    end
  end

  def params_signed http_action, query_hash
    string_to_sign = build_string_to_sign(http_action, query_hash)
    signature = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), AWS_SECRET_KEY, string_to_sign)
    query_hash.merge!(Signature: Base64.strict_encode64(signature))
  end

  def build_string_to_sign http_action, query_hash
    http_action.to_s.upcase + "\n" + URI.parse(AWS_ENDPOINT).host + "\n" + "/" + "\n" + query_hash.to_param
  end
end