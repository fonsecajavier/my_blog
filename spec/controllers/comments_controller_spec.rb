require "spec_helper"

describe CommentsController do
  before(:all) do
    @existing_post = create(:post)
  end

  it "should allow to enter a new comment to a given post and store it if valid.  Should show the post page with a flash notice message" do
    expect {
      post :create, {
        post_id: @existing_post.id,
        comment: attributes_for(:comment)
      }
    }.to change { @existing_post.comments.count }.by(1)
    flash[:notice].should_not be_nil
    response.should redirect_to(post_path(@existing_post))
  end

  it "shouldn't allow to enter an invalid comment to a given post.  Should show the post page with a flash error message" do
    expect {
      post :create, {
        post_id: @existing_post.id,
        comment: attributes_for(:invalid_comment)
      }
    }.to change { @existing_post.comments.count }.by(0)
    flash[:alert].should_not be_nil
    response.should redirect_to(post_path(@existing_post))
  end  
end