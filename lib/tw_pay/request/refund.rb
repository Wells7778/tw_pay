require 'faraday'
require 'json'
require_relative 'base'
require_relative '../response/refund'

module TwPay
  module Request
    class Refund < Base
      attr_accessor :bank_transaction_id,
                    :bank_transaction_uid,
                    :refund_amount

      private

      def response_klass
        Response::Refund
      end

      def txn_type
        'REFUND'
      end

      def to_hash
        {
          txnID: bank_transaction_id,
          txnUID: bank_transaction_uid,
          txnType: txn_type,
          refundAMT: refund_amount.to_s,
        }
      end

      def api_action
        'WebQR/api/TwmpTransRefund'
      end

      def verify_data
        ary = [
          bank_transaction_id,
          bank_transaction_uid,
          txn_type,
          refund_amount,
        ]
        ary.join()
      end
    end
  end
end
