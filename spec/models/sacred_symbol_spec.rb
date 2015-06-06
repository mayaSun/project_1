require 'spec_helper'

describe SacredSymbol do 

  it {should have_many(:products)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:image)}

  describe "search sacred symbol by name" do
    let(:mayami)  { Fabricate(:sacred_symbol, name: "Mayami")}
    let(:kalidaso)  { Fabricate(:sacred_symbol,name: "Kalidaso")}

    it "return array of  all the sacred symbol with a given name" do
      expect(SacredSymbol.search_by_name("Mayami")).to eq([mayami])
    end

    it "return array of  all the sacred symbols with a partial match" do
      expect(SacredSymbol.search_by_name("a")).to include(mayami)
      expect(SacredSymbol.search_by_name("a")).to include(kalidaso)
      expect(SacredSymbol.search_by_name("a").size).to eq(2)
    end

    it "return empty string when dosn't find sacred symbols with given name" do
      expect(SacredSymbol.search_by_name("q")).to eq([])
    end

    it "return array string when search_term is empty string" do
      expect(SacredSymbol.search_by_name("")).to eq([])
    end
  end

  it_behaves_like "slugable" do
    let(:object) { Fabricate(:sacred_symbol) }
  end

end