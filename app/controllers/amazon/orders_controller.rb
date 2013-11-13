class Amazon::OrdersController < Amazon::BaseController
  def list_orders
    conn = get_conn
    query = build_query(
              Action: "ListOrders",
              MarketplaceId: AWS_MARKETPLACE_ID,
              Version: '2011-01-01',
              CreatedAfter: Time.now.utc.iso8601
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
    query = build_query(Action: "ListOrders", Version: '2011-01-01' )
    @resp = conn.get do |req|
      req.url "/Orders/2011-11-01" # set req.url used by params_signed method
      req.url "/Orders/2011-11-01?#{params_signed(req, query).to_param}"
      req.headers['Content-Type'] = 'application/xml'
    end
    render :feed
  end
end