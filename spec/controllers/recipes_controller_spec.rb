require 'rails_helper'

RSpec.describe RecipesController, type: :controller do

  describe "root route" do
    it "routes to recipes#index" do
      expect(:get => '/').to route_to(:controller => "recipes", :action => "index")
    end
  end

  describe "GET #index" do
    it "routes correctly" do
      get :index
      expect(response.status).to eq(200)
    end

    it "renders the index template and sorts by name by default" do
      x, y = Recipe.create!, Recipe.create!
      expect(Recipe).to receive(:sorted_by).with("name") { [x,y] }
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:recipes)).to match_array([x,y])
    end
  end

  describe "GET #show" do
    it "routes correctly" do
      expect(Recipe).to receive(:find).with("1") { p }
      get :show, id: 1
      p = Recipe.new
      expect(response.status).to eq(200)
    end

    it "renders the show template" do
      expect(Recipe).to receive(:find).with("1") { p }
      get :show, id: 1
      expect(response).to render_template(:show)
    end
  end

describe "POST #create" do
  #####
    it "should show redirect to index on the create good" do
      p = Recipe.new
      Recipe.should_receive(:new).and_return(p)
      p.should_receive(:save).and_return(true)
      post :create, { :recipe => { "name"=>"dummy", "cooking_time"=>"1", "change_ingredients"=>"Jam 1"} }
      response.should redirect_to(recipes_path)
    end


    it "should show redirect to new on the create fail" do
      p = Recipe.new
      Recipe.should_receive(:new).and_return(p)
      p.should_receive(:save).and_return(nil)
      post :create, { :recipe => {"name"=>"tester_Cfail", "cooking_time"=>"1", "change_ingredients"=>"Jam 1"}} 
      response.should redirect_to(new_recipe_path)
    end
  end

  describe "PUT #update" do
  #####
     it "should show redirect to show on the update good" do
      p = Recipe.create!
      expect(p).to receive(:update).and_return(true)
      expect(Recipe).to receive(:find).and_return(p)
      expect(p).to receive(:save).and_return(true)#nil for fail
      put :update, :id => p.id, :recipe => {"name"=>"tester", "cooking_time"=>"1", "change_ingredients"=>"Jam 1"}
      response.should redirect_to("/recipes/#{p.id}")
    end


    it "should show redirect to edit on the update fail" do
      p = Recipe.create!
      expect(p).to receive(:update).and_return(true)
      expect(Recipe).to receive(:find).and_return(p)
      expect(p).to receive(:save).and_return(nil)#nil for fail
      put :update, :id => p.id, :recipe => {"name"=>"tester", "cooking_time"=>"1", "change_ingredients"=>"Jam 1"}
      response.should redirect_to("/recipes/#{p.id}/edit")
    end
  end
end

