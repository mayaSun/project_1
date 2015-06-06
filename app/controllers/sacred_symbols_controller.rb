class SacredSymbolsController <ApplicationController
  def show
    @sacred_symbol = SacredSymbol.find_by(slug: params[:id])
    @products = @sacred_symbol.products
  end
end