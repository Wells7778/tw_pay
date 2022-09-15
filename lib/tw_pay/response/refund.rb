require_relative 'base'
require_relative 'result'

module TwPay
  module Response
    class Refund < Result

      def refund_amount
        payload['refundAMT']
      end

      def refund?
        pay_status == 'R'
      end

      private

      def payload
        return {} if code != '0000'

        @payload ||= JSON.parse @refund_content rescue {}
      end
    end
  end
end
