require "spec_helper"

describe "Routes Helpers" do
  it "routes root (/) to posts#index" do
    get("/").should route_to("posts#index")
  end
end