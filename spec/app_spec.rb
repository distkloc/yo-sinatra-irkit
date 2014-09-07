require File.expand_path '../spec_helper.rb', __FILE__

describe "The Sinatra App for yo-irkit" do
  describe "root" do
    before { get '/' }

    it "should not authorize access" do
      expect(last_response.status).to eq(401)
    end
  end
end
