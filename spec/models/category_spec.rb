require 'spec_helper'

describe Category do 

  it {should have_many(:products)}
  it { should validate_presence_of(:name) }

  describe "search category by name" do
    let(:brass) { Fabricate(:category, name: "brass")}
    let(:silver) { Fabricate(:category, name: "silver")}

    it "return array of  all the category with a given name" do
      expect(Category.search_by_name("silver")).to eq([silver])
    end

    it "return array of all the category with a partial match" do
      expect(Category.search_by_name("s")).to include(brass)
      expect(Category.search_by_name("s")).to include(silver)
      expect(Category.search_by_name("s").size).to eq(2)
    end

    it "return empty string when dosn't find category with given name" do
      expect(Category.search_by_name("q")).to eq([])
    end

    it "return array string when search_term is empty string" do
      expect(Category.search_by_name("")).to eq([])
    end
  end

  it_behaves_like "slugable" do
    let(:object) { Fabricate(:category) }
  end

end