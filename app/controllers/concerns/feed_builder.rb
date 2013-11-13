module FeedBuilder

  def products_xml_builder product_barcodes
    xm = Builder::XmlMarkup.new
    xm.instruct! :xml, :version => "1.0", :encoding => "iso-8859-1"

    xm.AmazonEnvelope(
      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd"
    ){
      xm.Header {
        xm.DocumentVersion("1.01")
        xm.MerchantIdentifier(AWS_MERCHANT_ID)
      }
      xm.MessageType("Product")
      xm.PurgeAndReplace("false")

      # product data
      product_barcodes.each do |barcode|
        product = barcode.product

        xm.Message {
          xm.MessageID(barcode.id)
          xm.OperationType("Update")
          xm.Product {
            xm.SKU("#{product.id}-#{barcode.id}")
            xm.StandardProductID {
              xm.Type("UPC")
              xm.Value(barcode.barcode)
            }
            xm.ProductTaxCode("A_GEN_NOTAX")
            xm.NumberOfItems((product.real_time_quantity.present? && product.real_time_quantity > 0) ? product.real_time_quantity : '100')
            xm.DescriptionData {
              xm.Title(product.name)
              xm.Brand(product.printer_brand ? product.printer_brand.name : '')
              xm.Description(product.description)
              xm.BulletPoint(product.product_type)
              xm.MSRP(product.retail_price, currency: "USD")
            }
            xm.ProductData {
              xm.Office {
                xm.ProductType {
                  xm.OfficeProducts {
                    xm.NumberOfItems((product.real_time_quantity.present? && product.real_time_quantity > 0) ? product.real_time_quantity : '100')
                  }
                }
              }
            }
          }
        }
      end
    }
  end

  def price_xml_builder product_barcodes
    xm = Builder::XmlMarkup.new
    xm.instruct! :xml, :version => "1.0", :encoding => "iso-8859-1"

    xm.AmazonEnvelope(
      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd"
    ){
      xm.Header {
        xm.DocumentVersion("1.01")
        xm.MerchantIdentifier(AWS_MERCHANT_ID)
      }
      xm.MessageType("Price")

      # product data
      product_barcodes.each do |barcode|
        product = barcode.product

        xm.Message {
          xm.MessageID(product.id)
          xm.OperationType("Update")
          xm.Price {
            xm.SKU("#{product.id}-#{barcode.id}")
            xm.StandardPrice(product.retail_price, currency: "USD")
          }
        }
      end
    }
  end

  def inventory_xml_builder product_barcodes
    xm = Builder::XmlMarkup.new
    xm.instruct! :xml, :version => "1.0", :encoding => "iso-8859-1"

    xm.AmazonEnvelope(
      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd"
    ){
      xm.Header {
        xm.DocumentVersion("1.01")
        xm.MerchantIdentifier(AWS_MERCHANT_ID)
      }
      xm.MessageType("Inventory")

      # product data
      product_barcodes.each do |barcode|
        product = barcode.product

        xm.Message {
          xm.MessageID(barcode.id)
          xm.OperationType("Update")
          xm.Inventory {
            xm.SKU("#{product.id}-#{barcode.id}")
            xm.Quantity((product.real_time_quantity.present? && product.real_time_quantity > 0) ? product.real_time_quantity : '100')
          }
        }
      end
    }
  end

end
