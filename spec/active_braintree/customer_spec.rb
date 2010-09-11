require 'spec_helper'

module ActiveBraintree
  describe Customer do
    before do
      CreditCard.stub(:new)
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

      describe '#errors' do
        subject do
          customer = Customer.new(:transparent_redirect_result => failed_tr_customer_result_stub)
          customer.errors
        end

        it 'has errors on email' do
          subject.on(:email).should == 'Email is an invalid format.'
        end

        it 'has no errors on first_name' do
          subject.on(:first_name).should be_nil
        end

        it 'has 1 error' do
          subject.size.should == 1
        end
      end
    end
  end
end
