shared_examples "require_admin" do

  it "redirect to the home page" do
    clear_current_user
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
    
end

shared_examples "require_user" do

  it "redirect to the home page" do
    clear_current_user
    action
    expect(response).to redirect_to home_path
  end
    
end

shared_examples "slugable" do

  it "set the slug" do
    object.generate_slug!
    expect(object.slug).to_not be_nil
  end

end