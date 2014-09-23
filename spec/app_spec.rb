require File.expand_path '../spec_helper.rb', __FILE__

describe "The Sinatra App for yo-irkit" do

  describe "root" do
    before { get '/' }

    it "should not authorize access" do
      expect(last_response.status).to eq(401)
    end
  end

  describe '#on_hook', :vcr do

    context "with valid user" do
      context "and valid token" do
        before { switch_on }
        it 'switch on' do
          expect(last_response).to be_ok
        end
      end

      context "and invalid token" do
        before { switch_on(token: "") }
        it "should not authorize" do
          expect(last_response.status).to eq(401)
        end
      end
    end

    context "without valid user" do
      before { switch_on(username: "") }
      it "should not authorize" do
        expect(last_response.status).to eq(401)
      end
    end

    describe 'irkit response' do

      context "with invalid device id" do
        before do
          ENV['IRKIT_DEVICE_ID'] += "invalid"
          switch_on
        end

        it 'should not authorize' do
          expect(last_response.status).to eq(401)
        end
      end


      context "with invalid client key" do
        before do
          ENV['IRKIT_CLIENT_KEY'] += "invalid"
          switch_on
        end

        it 'should not authorize' do
          expect(last_response.status).to eq(401)
        end
      end

    end
  end
end
