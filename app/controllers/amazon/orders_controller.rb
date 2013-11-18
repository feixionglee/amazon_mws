class Amazon::OrdersController < Amazon::BaseController
  def list_orders
    conn = get_conn
    query = build_query(
              Action: "ListOrders",
              "MarketplaceId.Id.1" => AWS_MARKETPLACE_ID,
              SellerId: AWS_MERCHANT_ID,
              Version: '2011-01-01',
              CreatedAfter: (Date.today.to_time - 10.days).utc.iso8601
            )
    @resp = conn.get do |req|
      req.url "/Orders/2011-11-01" # set req.url used by params_signed method
      req.url "/Orders/2011-11-01?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
    end
    render :feed
  end

  def get_order
    conn = get_conn
    query = build_query(
              Action: "GetOrder",
              Version: '2011-01-01',
              "AmazonOrderId.Id.1" => params[:id],
              SellerId: AWS_MERCHANT_ID
            )
    @resp = conn.get do |req|
      req.url "/Orders/2011-11-01" # set req.url used by params_signed method
      req.url "/Orders/2011-11-01?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
    end
    render :feed
  end
end