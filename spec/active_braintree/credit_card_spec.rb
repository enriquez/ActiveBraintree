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
    end

    describe '#errors' do
      context 'after initialization' do
        it 'has no errors' do
          subject.should have(:no).errors
        end
      end

      context 'after initialization with a successful result' do
        subject { CreditCard.new(:transparent_redirect_result => successful_tr_customer_result_stub) }

        it 'has no errors' do
          subject.should have(:no).errors
        end
      end

      context 'after initialization with a failed result' do
        subject { CreditCard.new(:transparent_redirect_result => failed_tr_customer_result_stub) }

        it 'has 2 errors' do
          subject.should have(2).errors
        end

        it 'has errors on number' do
          subject.errors.on(:number).should == [
            '^Credit card number must be 12-19 digits.',
            '^Credit card type is not accepted by this merchant account.'
          ]
        end

        it 'has no errors on cardholder_name' do
          subject.errors.on(:cardholder_name).should be_nil
        end
      end
    end

    describe '.human_name' do
      it 'returns "Credit Card"' do
        CreditCard.human_name.should == 'Credit Card'
      end
    end

    describe '.human_attribute_name' do
      it 'returns a human friendly version for cardholder_name' do
        CreditCard.human_attribute_name('cardholder_name').should == 'Cardholder name'
      end

      it 'returns a human friendly version for number' do
        CreditCard.human_attribute_name('number').should == 'Number'
      end

      it 'returns a human friendly version for cvv' do
        CreditCard.human_attribute_name('cvv').should == 'Cvv'
      end

      it 'returns a human friendly version for expiration_date' do
        CreditCard.human_attribute_name('expiration_date').should == 'Expiration date'
      end

      it 'returns a human friendly version for expiration_month' do
        CreditCard.human_attribute_name('expiration_month').should == 'Expiration month'
      end

      it 'returns a human friendly version for expiration_year' do
        CreditCard.human_attribute_name('expiration_year').should == 'Expiration year'
      end
    end
  end
end
