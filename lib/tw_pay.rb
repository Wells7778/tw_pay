# frozen_string_literal: true

require_relative "tw_pay/version"
require_relative "tw_pay/config"
require_relative "tw_pay/configure"
require_relative "tw_pay/request"
require_relative "tw_pay/response"
module TwPay
  class Error < StandardError; end

  def self.setup
    yield config
  end

  def self.config
    @config ||= TwPay::Configure.new
  end
end
