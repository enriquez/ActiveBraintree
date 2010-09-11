module ActiveBraintree
  class Base
    include MagicAttributes

    def valid?
      @errors.empty?
    end

    protected
    def add_errors errors
      errors.each do |error|
        @errors.add(error.attribute, error.message)
      end
    end
  end
end
