module ActiveBraintree
  class Customer < Base
    attributes :company, :email, :fax, :first_name, :last_name, :phone, :website
    attr_reader :errors

    def initialize(opts = {})
      result = opts[:transparent_redirect_result]

      if result
        @errors = ActiveRecord::Errors.new(self)
        add_errors(result.errors.for(:customer)) unless result.success?

        customer_result = normalized_customer(result)
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
