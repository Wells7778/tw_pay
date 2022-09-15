require_relative 'base'

module TwPay
  module Response
    class Pay < Base
      def qrcode
        @qrcode
      end

      def bank_transaction_id
        @txnID
      end

      def payment_url
        @TwmpURL
      end
    end
  end
end
