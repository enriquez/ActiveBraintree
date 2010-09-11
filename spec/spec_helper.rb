require 'rspec'
require 'active_braintree'

def successful_tr_customer_result_stub
  result = mock('result')
  customer = mock('customer')
  credit_card = mock('credit card')

  result.stub(:success?).and_return(true)
  result.stub(:customer).and_return(customer)

  customer.stub(:first_name)        .and_return('Mike')
  customer.stub(:last_name)         .and_return('Enriquez')
  customer.stub(:company)           .and_return('EdgeCase')
  customer.stub(:email)             .and_return('mike@edgecase.com')
  customer.stub(:phone)             .and_return('1231231234')
  customer.stub(:fax)               .and_return('3213214321')
  customer.stub(:website)           .and_return('edgecase.com')
  customer.stub_chain(:credit_cards).and_return([credit_card])

  credit_card.stub(:cardholder_name) .and_return('Michael Enriquez')
  credit_card.stub(:expiration_date) .and_return('12/2015')
  credit_card.stub(:expiration_month).and_return('12')
  credit_card.stub(:expiration_year) .and_return('2015')

  result
end

def failed_tr_customer_result_stub
  result = mock('result')
  credit_card_error_1 = mock('credit card error 1')
  credit_card_error_2 = mock('credit card error 2')
  customer_error = mock('customer error')

  result.stub(:success?).and_return(false)
  result.stub(:params).and_return(
    {
      :customer => {
        :first_name => 'Mike',
        :last_name => 'Enriquez',
        :company => 'EdgeCase',
        :email => 'invalidemail',
        :phone => '1231231234',
        :fax => '3213214321',
        :website => 'edgecase.com',
        :credit_card => {
          :options => { :verify_card => 'true' },
          :cardholder_name => 'Michael Enriquez',
          :expiration_month => '12',
          :expiration_year => '2015',
          :expiration_date => '12/2015'
        }
      }
    }
  )
  credit_card_errors = [credit_card_error_1, credit_card_error_2]

  customer_errors = [customer_error]
  customer_errors.stub(:for).and_return(credit_card_errors)

  result.stub_chain(:errors, :for).and_return(customer_errors)

  credit_card_error_1.stub(:attribute).and_return('number')
  credit_card_error_1.stub(:message).and_return('Credit card number must be 12-19 digits.')
  credit_card_error_1.stub(:code).and_return('81716')

  credit_card_error_2.stub(:attribute).and_return('number')
  credit_card_error_2.stub(:message).and_return('Credit card type is not accepted by this merchant account.')
  credit_card_error_2.stub(:code).and_return('81703')

  customer_error.stub(:attribute).and_return('email')
  customer_error.stub(:message).and_return('Email is an invalid format.')
  customer_error.stub(:code).and_return('81604')

  result
end
