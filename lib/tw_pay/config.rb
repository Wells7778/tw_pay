module TwPay
  class Config
    attr_accessor :mode, :key, :merchant_id, :terminal_id

    def initialize
      @mode = :sandbox
    end

    def production?
      @mode != :sandbox
    end

    def api_host
      return TwPay.config.host if production?
      TwPay.config.sandbox_host
    end
  end
end