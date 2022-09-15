require 'faraday'
require 'json'

module TwPay
  module Request
    class Base

      attr_accessor :config
      attr_reader :response_raw

      def initialize(params=nil)
        return unless params.is_a? Hash

        @config = nil
        params.each do |key, value|
          send "#{key}=", value
        end
        post_initialize
      end

      def request
        raise TwPay::Error, "Missing Merchant ID" unless config&.merchant_id
        raise TwPay::Error, "Missing Terminal ID" unless config&.terminal_id

        res = send_request
        return res unless response_klass
        @response_raw = res.body
        result = JSON.parse res.body rescue {}
        response_klass.new(result, raw: res.body)
      end

      def request_raw
        request_data
      end

      private

      def post_initialize; end

      def response_klass; end

      def acq_bank
        '009'
      end

      def currency
        '901'
      end

      def to_hash
        {
          acqBank: acq_bank,
          merchantId: config.merchant_id,
          currency: currency,
          terminalId: config.terminal_id,
        }
      end

      def api_action
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def request_data
        to_hash.merge(verifyCode: verify_code)
      end

      def verify_data
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def verify_code
        code = aes pack(TwPay.config.key), pack(Digest::SHA2.hexdigest(verify_data).upcase)
        code.unpack('H*')[0]
      end

      def send_request
        conn = Faraday.new(
          url: api_host,
          headers: { 'Content-Type' => 'application/json' }
        )
        res = conn.post(api_action) do |req|
          req.body = request_data.to_json
        end
        return if res.status != 200

        res
      end

      def api_host
        config&.api_host
      end

      def pack(data)
        [data].pack('H*')
      end

      def aes(key, string)
        cipher = OpenSSL::Cipher.new('des-ede3-cbc')
        cipher.encrypt
        cipher.key = key
        cipher.padding = 0
        cipher.iv = TwPay.config.iv
        encrypted = ''
        encrypted << cipher.update(string)
        encrypted << cipher.final
        encrypted
      end
    end
  end
end