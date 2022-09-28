require_relative 'base'
require_relative '../utils/emv_qrcode/decoder.rb'

module TwPay
  module Response
    class Pay < Base
      def qrcode
        format_qrcode
      end

      def bank_transaction_id
        @txnID
      end

      def payment_url
        @TwmpURL
      end

      private

      def format_qrcode
        decoder = Utils::EmvQrcode::Decoder.new @qrcode
        data = decoder.decode
        scheme = 'TWQRP://'
        host = decoder.get :language_template, :merchant_name
        path = "#{decoder.get(:tw_payment_info, :merchant_info)[0, 2]}/01/#{decoder.get(:tw_payment_info, :merchant_info)[2, 3]}"
        query = {
          D1: decoder.get(:transaction_amount),
          D2: decoder.get(:additional_data_field, :bill_number),
          D3: decoder.get(:tw_payment_info, :merchant_info)[5, 12],
          D10: decoder.get(:transaction_currency),
          D11: decoder.get(:tw_payment_info, :merchant_info)[17..-1],
        }.map {|k, v| "#{k.to_s}=#{v}"}.join('&')

        "#{scheme}#{host}/#{path}?#{query}"
      end
    end
  end
end
