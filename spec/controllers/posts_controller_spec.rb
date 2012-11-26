require "spec_helper"

describe PostsController do

  context "all users" do
    it "should be presented with a list of all posts at index, ordered from newest to oldest" do
      4.times { create(:post) }
      get :index
      assigns[:posts].should have_at_least(4).posts
      assigns[:posts].map(&:id).should eql(
        assigns[:posts].sort { |x, y| y[:id] <=> x[:id] }.map(&:id)
      )
      response.should render_template(:index)
    end

    it "should be presented with a requested post and its comments (from oldest to newest) in the show action" do
      existing_post = create(:post)
      4.times { create(:comment, post_id: existing_post.id) }
      get :show, id: existing_post.id
      assigns[:post].should == existing_post
      assigns[:comments].count.should eql(4)
      assigns[:comments].map(&:id).should eql(
        assigns[:comments].sort { |x, y| x[:id] <=> y[:id] }.map(&:id)
      )
      response.should render_template(:show)
    end

  end
  
  context "not logged in user should be redirected to sign in path when" do
    it "trying to go to the new post page" do
      get :new
      response.should_not be_success
    end

    it "submitting form on new post page" do
      post :create
      response.should_not be_success
    end

    it "trying to go to the edit post page" do
      get :edit, id: create(:post).id
      response.should_not be_success
    end

    it "trying to submit an update for an existing post.  The post shouldn't be changed" do
      existing_post = create(:post)
      put :update, {
        id: existing_post.id,
        post: { title: "Title changed" }
      }
      existing_post.reload.title.should_not eql("Title changed")
      response.should_not be_success
    end
  end

  context "logged in user" do
    login_user
    
    it "should be able to see the new post page" do
      get :new
      response.should render_template(:new)
    end

    it "should be able to create a new post and be redirected to such post page with a flash notice message" do
      expect {
        post :create, {:post => attributes_for(:post)}
        created_post = assigns[:post]
        created_post.should_not be_new_record
        response.should redirect_to(post_path(created_post))
        created_post.user.should == @logged_in_user
        flash[:notice].should_not be_nil
      }.to change { Post.count }.by(1)
    end

    it "shouldn't be able to create an invalid post.  Should be instead redirected to the new post page with a flash error message" do
      expect {
        post :create, {:post => attributes_for(:invalid_post)}
        created_post = assigns[:post]
        created_post.should be_new_record
        response.should render_template(:new)
        flash[:error].should_not be_nil
      }.to change { Post.count }.by(0)
    end

    it "should be able to go the 'edit a post' page" do
      existing_post = create(:post)
      get :edit, id: existing_post.id
      response.should render_template(:edit)
    end

    it "should be able to submit an update for an existing post.  The post should be changed and the user redirected to the show page with a flash notice message" do
      existing_post = create(:post)
      put :update, {
        id: existing_post.id,
        post: { title: "Title changed" }
      }
      existing_post.reload.title.should eql("Title changed")
      flash[:notice].should_not be_nil
      response.should redirect_to(post_path(existing_post))
    end

    it "shouldn't be able to update an existing post with invalid values.  Should be presented with the same edit page and a flash error message" do
      existing_post = create(:post)
      put :update, {
        id: existing_post.id,
        post: { title: "" }
      }
      existing_post.reload.title.should_not eql("")
      flash[:error].should_not be_nil
      response.should render_template(:edit)
    end
  end

end