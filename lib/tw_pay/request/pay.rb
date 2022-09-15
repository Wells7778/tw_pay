require 'faraday'
require 'json'
require_relative 'base'
require_relative '../response/pay'

module TwPay
  module Request
    class Pay < Base
      attr_accessor :order_id,
                    :amount,
                    :mobile,
                    :confirm_url

      private

      def response_klass
        Response::Pay
      end

      def txn_type
        mobile ? 'A' : 'P'
      end

      def qrcode_type
        return if mobile

        '1'
      end

      def callback_url
        return unless mobile

        confirm_url
      end

      def to_hash
        super.merge(
          orderNo: order_id.to_s,
          transAMT: amount.to_s,
          txnType: txn_type,
          qrcodeType: qrcode_type,
          callbackURL: callback_url
        ).compact
      end

      def api_action
        'WebQR/api/MerchantNotifyTwmpTrans'
      end

      def verify_data
        ary = [
          acq_bank,
          config.merchant_id,
          config.terminal_id,
          order_id,
          amount,
          currency,
          txn_type,
        ]
        ary << callback_url if mobile
        ary.join()
      end
    end
  end
end
