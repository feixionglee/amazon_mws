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

  def params_signed request, query_hash
    string_to_sign = build_string_to_sign(request, query_hash)
    signature = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), AWS_SECRET_KEY, string_to_sign)
    query_hash.merge!(Signature: Base64.strict_encode64(signature))
  end

  def build_string_to_sign request, query_hash
    request.method.to_s.upcase
    .concat("\n")
    .concat(URI.parse(AWS_ENDPOINT).host)
    .concat("\n")
    .concat(request.path)
    .concat("\n")
    .concat(query_hash.to_param)
  end
end