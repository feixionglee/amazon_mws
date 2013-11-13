class Amazon::FeedsController < Amazon::BaseController
  include FeedBuilder

  def submit_feed
    conn = get_conn
    query = build_query(Action: "SubmitFeed", FeedType: "_POST_PRODUCT_DATA_")
    @resp = conn.post do |req|
      req.url "/"
      req.url "/?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
      req.headers['Content-MD5'] = Base64.strict_encode64(Digest::MD5.digest(products_xml_builder(products)))
      req.body = products_xml_builder(products)
    end
    render :feed
  end

  def get_feed_submission_list
    conn = get_conn
    query = build_query(Action: "GetFeedSubmissionList")
    @resp = conn.get do |req|
      req.url "/"
      req.url "/?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
    end
    render :feed
  end

  def get_feed_submission_result
    conn = get_conn
    query = build_query(Action: "GetFeedSubmissionResult", FeedSubmissionId: params[:subsession_id])
    @resp = conn.get do |req|
      req.url "/"
      req.url "/?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
    end
    render :feed
  end

  def get_feed_submission_count
    conn = get_conn
    query = build_query(Action: "GetFeedSubmissionCount", 'FeedTypeList.Type.1' => '_POST_PRODUCT_DATA_')
    @resp = conn.get do |req|
      req.url "/"
      req.url "/?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
    end
    render :feed
  end
end