module ActiveBraintree
  class CreditCard < Base
    attributes :cardholder_name, :number, :cvv, :expiration_date, :expiration_month, :expiration_year
    attr_reader :errors

    def initialize(opts = {})
      @errors = ActiveRecord::Errors.new(self)
      credit_card_result = opts[:transparent_redirect_result]

      if credit_card_result && credit_card_result.success?
        credit_card_result = opts[:transparent_redirect_result].customer.credit_cards.first
        set_attributes(credit_card_result, :except => [:number, :cvv])
      elsif credit_card_result && !credit_card_result.success?
        credit_card_result.errors.for(:customer).for(:credit_card).each do |error|
          @errors.add(error.attribute, error.message)
        end
        set_attributes(credit_card_result.params[:customer][:credit_card], :except => [:number, :cvv])
      end
    end
  end
end
