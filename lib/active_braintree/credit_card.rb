module ActiveBraintree
  class CreditCard < Base
    attributes :cardholder_name, :number, :cvv, :expiration_date, :expiration_month, :expiration_year
    attr_reader :errors

    def initialize(opts = {})
      result = opts[:transparent_redirect_result]

      if result
        @errors = ActiveRecord::Errors.new(self)
        add_errors(result.errors.for(:customer).for(:credit_card)) unless result.success?

        credit_card_result = normalized_credit_card(result)
        set_attributes(credit_card_result, :except => [:number, :cvv])
      end
    end

    protected
    def normalized_credit_card result
      if result.respond_to?(:customer)
        result.customer.credit_cards.first
      elsif result.respond_to?(:params)
        OpenStruct.new(result.params[:customer][:credit_card])
      end
    end
  end
end
