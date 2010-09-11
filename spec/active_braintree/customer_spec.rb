require 'spec_helper'

module ActiveBraintree
  describe Customer do
    before do
      credit_card = mock('credit card', :errors => [])
      CreditCard.stub(:new).and_return(credit_card)
    end

    context 'initialization' do
      it 'sets first_name to nil' do
        subject.first_name.should be_nil
      end

      it 'sets last_name to nil' do
        subject.last_name.should be_nil
      end

      it 'sets company to nil' do
        subject.company.should be_nil
      end

      it 'sets email to nil' do
        subject.email.should be_nil
      end

      it 'sets phone to nil' do
        subject.phone.should be_nil
      end

      it 'sets fax to nil' do
        subject.fax.should be_nil
      end

      it 'sets website to nil' do
        subject.website.should be_nil
      end

      it 'sets creates a new CreditCard' do
        CreditCard.should_receive(:new).with()
        Customer.new
      end
    end

    context 'initialization with a successful transparent redirect' do
      subject do
        Customer.new(:transparent_redirect_result => successful_tr_customer_result_stub)
      end

      it { should be_valid }

      it 'sets the first_name' do
        subject.first_name.should == 'Mike'
      end

      it 'sets the last_name' do
        subject.last_name.should == 'Enriquez'
      end

      it 'sets company' do
        subject.company.should == 'EdgeCase'
      end

      it 'sets email' do
        subject.email.should == 'mike@edgecase.com'
      end

      it 'sets phone' do
        subject.phone.should == '1231231234'
      end

      it 'sets fax' do
        subject.fax.should == '3213214321'
      end

      it 'sets website' do
        subject.website.should == 'edgecase.com'
      end

      it 'sets creates a new CreditCard and passes the tr object' do
        result = successful_tr_customer_result_stub
        CreditCard.should_receive(:new).with(:transparent_redirect_result => result)
        Customer.new(:transparent_redirect_result => result)
      end
    end

    context 'initialization with a failed transparent redirect' do
      subject do
        Customer.new(:transparent_redirect_result => failed_tr_customer_result_stub)
      end

      it { should_not be_valid }

      it 'sets the first_name' do
        subject.first_name.should == 'Mike'
      end

      it 'sets the last_name' do
        subject.last_name.should == 'Enriquez'
      end

      it 'sets company' do
        subject.company.should == 'EdgeCase'
      end

      it 'sets email' do
        subject.email.should == 'invalidemail'
      end

      it 'sets phone' do
        subject.phone.should == '1231231234'
      end

      it 'sets fax' do
        subject.fax.should == '3213214321'
      end

      it 'sets website' do
        subject.website.should == 'edgecase.com'
      end

      it 'sets creates a new CreditCard and passes the tr object' do
        result = failed_tr_customer_result_stub
        CreditCard.should_receive(:new).with(:transparent_redirect_result => result)
        Customer.new(:transparent_redirect_result => result)
      end
    end

    describe '#errors' do
      context 'after initialization' do
        it 'has no errors' do
          subject.should have(:no).errors
        end
      end

      context 'after initialization with a successful result' do
        subject { Customer.new(:transparent_redirect_result => successful_tr_customer_result_stub) }

        it 'has no errors' do
          subject.should have(:no).errors
        end
      end

      context 'after initialization with a failed result' do
        subject { Customer.new(:transparent_redirect_result => failed_tr_customer_result_stub) }

        it 'has 3 errors' do
          subject.should have(3).errors
        end

        it 'has errors on email' do
          subject.errors.on(:email).should == '^Email is an invalid format.'
        end

        it 'has errors on base' do
          subject.errors.on_base.should == [
            'Credit card number must be 12-19 digits.',
            'Credit card type is not accepted by this merchant account.'
          ]
        end

        it 'has no errors on first_name' do
          subject.errors.on(:first_name).should be_nil
        end
      end
    end

    describe '.human_name' do
      it 'returns "Customer"' do
        Customer.human_name.should == 'Customer'
      end
    end

    describe '.human_attribute_name' do
      it 'returns a human friendly version for first_name' do
        Customer.human_attribute_name('first_name').should == 'First name'
      end

      it 'returns a human friendly version for last_name' do
        Customer.human_attribute_name('last_name').should == 'Last name'
      end

      it 'returns a human friendly version for company' do
        Customer.human_attribute_name('company').should == 'Company'
      end

      it 'returns a human friendly version for email' do
        Customer.human_attribute_name('email').should == 'Email'
      end

      it 'returns a human friendly version for phone' do
        Customer.human_attribute_name('phone').should == 'Phone'
      end

      it 'returns a human friendly version for fax' do
        Customer.human_attribute_name('fax').should == 'Fax'
      end

      it 'returns a human friendly version for website' do
        Customer.human_attribute_name('website').should == 'Website'
      end
    end
  end
end
