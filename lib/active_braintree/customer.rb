module ActiveBraintree
  class Customer < Base
    attributes :company, :email, :fax, :first_name, :last_name, :phone, :website
    attr_reader :errors, :credit_card

    def initialize(opts = {})
      result = opts[:transparent_redirect_result]
      @errors = ActiveRecord::Errors.new(self)

      if result
        add_errors(result.errors.for(:customer)) unless result.success?
        add_errors(result.errors.for(:customer).for(:credit_card), :on_base => true) unless result.success?

        customer_result = normalized_customer(result)
        set_attributes(customer_result)
        @credit_card = CreditCard.new(:transparent_redirect_result => result)
      else
        @credit_card = CreditCard.new
      end
    end

    def valid?
      @errors.empty? && @credit_card.errors.empty?
    end

    def self.human_name
      'Customer'
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
