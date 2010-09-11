require 'spec_helper'

module ActiveBraintree
  describe CreditCard do
    context 'initialization' do
      it 'sets cardholder_name to nil' do
        subject.cardholder_name.should be_nil
      end

      it 'sets number to nil' do
        subject.number.should be_nil
      end

      it 'sets cvv to nil' do
        subject.cvv.should be_nil
      end

      it 'sets expiration_date to nil' do
        subject.expiration_date.should be_nil
      end

      it 'sets expiration_month to nil' do
        subject.expiration_month.should be_nil
      end

      it 'sets expiration_year to nil' do
        subject.expiration_year.should be_nil
      end
    end

    context 'initialization with a successful transparent redirect' do
      subject do
        CreditCard.new(:transparent_redirect_result => successful_tr_customer_result_stub)
      end

      it { should be_valid }

      it 'set the cardholder_name' do
        subject.cardholder_name.should == 'Michael Enriquez'
      end

      it 'set the expiration_date' do
        subject.expiration_date.should == '12/2015'
      end

      it 'set the expiration_month' do
        subject.expiration_month.should == '12'
      end

      it 'set the expiration_year' do
        subject.expiration_year.should == '2015'
      end
    end

    context 'initialization with a failed transparent redirect' do
      subject do
        CreditCard.new(:transparent_redirect_result => failed_tr_customer_result_stub)
      end

      it { should_not be_valid }

      it 'set the cardholder_name' do
        subject.cardholder_name.should == 'Michael Enriquez'
      end

      it 'set the expiration_date' do
        subject.expiration_date.should == '12/2015'
      end

      it 'set the expiration_month' do
        subject.expiration_month.should == '12'
      end

      it 'set the expiration_year' do
        subject.expiration_year.should == '2015'
      end

      describe '#errors' do
        subject do
          credit_card = CreditCard.new(:transparent_redirect_result => failed_tr_customer_result_stub)
          credit_card.errors
        end

        it 'has errors on number' do
          subject.on(:number).should == [
            'Credit card number must be 12-19 digits.',
            'Credit card type is not accepted by this merchant account.'
          ]
        end

        it 'has no errors on cardholder_name' do
          subject.on(:cardholder_name).should be_nil
        end

        it 'has 2 errors' do
          subject.size.should == 2
        end
      end
    end
  end
end
