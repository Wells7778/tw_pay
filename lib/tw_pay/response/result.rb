require_relative 'base'

module TwPay
  module Response
    class Result < Base

      def order_id
        payload['orderNo']
      end

      def amount
        payload['transAMT']
      end

      def bank_transaction_id
        payload['txnID']
      end

      def bank_transaction_uid
        payload['txnUID']
      end

      def transaction_time
        /\A(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})\Z/ =~ payload['txnDate']
        /\A(?<hour>\d{2})(?<minute>\d{2})(?<second>\d{2})\Z/ =~ payload['txnTime']
        DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i, '+8').to_i
      end

      def paid?
        pay_status == 'S'
      end

      def pay_status
        payload['payStatus']
      end

      private

      def payload
        @payload ||= JSON.parse @txn_content rescue {}
      end
    end
  end
end
