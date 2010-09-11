module ActiveBraintree
  class Customer < Base
    attributes :company, :email, :fax, :first_name, :last_name, :phone, :website
    attr_reader :errors

    def initialize(opts = {})
      @errors = ActiveRecord::Errors.new(self)
      customer_result = opts[:transparent_redirect_result]

      if customer_result && customer_result.success?
        customer_result = opts[:transparent_redirect_result].customer
        set_attributes(customer_result)
        @credit_card = CreditCard.new(:transparent_redirect_result => opts[:transparent_redirect_result])
      elsif customer_result && !customer_result.success?
        customer_result.errors.for(:customer).each do |error|
          @errors.add(error.attribute, error.message)
        end
        set_attributes(customer_result.params[:customer])
        @credit_card = CreditCard.new(:transparent_redirect_result => opts[:transparent_redirect_result])
      else
        @credit_card = CreditCard.new
      end
    end
  end
end
