module TwPay
  module Response
    class Base
      def initialize(params, resp=nil)
        params.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def success?
        code == '0000'
      end

      def error_message
        @msg
      end

      def code
        @code
      end
    end
  end
end
