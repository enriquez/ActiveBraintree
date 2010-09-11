module ActiveBraintree
  class Customer < Base
    attributes :company, :email, :fax, :first_name, :last_name, :phone, :website
    attr_reader :errors

    def initialize(opts = {})
      @errors = ActiveRecord::Errors.new(self)
      result = opts[:transparent_redirect_result]
      customer_result = normalized_customer(result)

      if customer_result && result.success?
        set_attributes(customer_result)
        @credit_card = CreditCard.new(:transparent_redirect_result => result)
      elsif customer_result && !result.success?
        result.errors.for(:customer).each do |error|
          @errors.add(error.attribute, error.message)
        end
        set_attributes(customer_result)
        @credit_card = CreditCard.new(:transparent_redirect_result => result)
      else
        @credit_card = CreditCard.new
      end
    end

    protected
    def normalized_customer result
      if result.respond_to?(:customer)
        result.customer
      elsif result.respond_to?(:params)
        OpenStruct.new(result.params[:customer])
      end
    end
  end
end
