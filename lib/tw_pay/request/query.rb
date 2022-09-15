require 'faraday'
require 'json'
require_relative 'base'
require_relative '../response/query'

module TwPay
  module Request
    class Query < Base
      attr_accessor :bank_transaction_id

      private

      def response_klass
        Response::Query
      end

      def to_hash
        { txnID: bank_transaction_id }
      end

      def api_action
        'WebQR/api/QryTwmpTrans'
      end

      def verify_data
        bank_transaction_id
      end
    end
  end
end
