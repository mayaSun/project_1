class Admin::SacredSymbolsController < AdminController

  def index
    @sacred_symbol = SacredSymbol.new
    @sacred_symbols = SacredSymbol.all
  end

  def create
    @sacred_symbol = SacredSymbol.new(sacred_symbol_params)
    if @sacred_symbol.save
      flash[:notice] = "#{@sacred_symbol.name} was added"
      redirect_to admin_sacred_symbols_path
    else
      flash[:error] = "The sacred symbol #{@sacred_symbol.name} was NOT added"
      @sacred_symbols = SacredSymbol.all
      render :index
    end  
  end

  def edit
    @sacred_symbol = SacredSymbol.find_by(slug: params[:id])
    @sacred_symbols = SacredSymbol.all
    render :index
  end

  def update
    @sacred_symbol = SacredSymbol.find_by(slug: params[:id])
    if @sacred_symbol.update_attributes(sacred_symbol_params)
      flash[:notice] = "#{@sacred_symbol.name} was updated"
      redirect_to admin_sacred_symbols_path
    else
      flash[:error] = "#{@sacred_symbol.name} was NOT updated"
      @sacred_symbols = SacredSymbol.all
      render :index
    end
  end

  def destroy
    sacred_symbol = SacredSymbol.find_by(slug: params[:id])
    sacred_symbol.delete
    flash[:notice] = "#{sacred_symbol.name} was deleted"
    redirect_to admin_sacred_symbols_path
  end


  private

  def sacred_symbol_params
    params.require(:sacred_symbol).permit(:name, :description, :image)
  end

end