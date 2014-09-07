require File.expand_path '../spec_helper.rb', __FILE__

describe "The Sinatra App for yo-irkit" do
  describe "root" do
    before { get '/' }

    it "should not authorize access" do
      expect(last_response.status).to eq(401)
    end
  end

  describe '#on_hook', :vcr do
    before do
      username = ENV['USER_NAME']
      api_key = ENV['API_KEY']
      get "/on_hook?username=#{username}&token=#{api_key}"
    end

    context "with valid user" do
      context "and valid token" do
        # specify { expect(last_response.status).to eq(401) }
        it 'switch on' do
          expect(last_response).to be_ok
        end
      end
    end
  end
end
