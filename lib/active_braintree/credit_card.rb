module ActiveBraintree
  class CreditCard < Base
    attributes :cardholder_name, :number, :cvv, :expiration_date, :expiration_month, :expiration_year
    attr_reader :errors

    def initialize(opts = {})
      @errors = ActiveRecord::Errors.new(self)
      result = opts[:transparent_redirect_result]
      credit_card_result = normalized_credit_card(result)

      if credit_card_result && result.success?
        set_attributes(credit_card_result, :except => [:number, :cvv])
      elsif credit_card_result && !result.success?
        result.errors.for(:customer).for(:credit_card).each do |error|
          @errors.add(error.attribute, error.message)
        end
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
