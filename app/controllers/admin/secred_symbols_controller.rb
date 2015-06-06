class Admin::SecredSymbolsController < AdminController

  def index
    @secred_symbol = SecredSymbol.new
    @secred_symbols = SecredSymbol.all
  end

  def create
    @secred_symbol = SecredSymbol.new(secred_symbol_params)
    if @secred_symbol.save
      flash[:notice] = "#{@secred_symbol.name} was added"
      redirect_to admin_secred_symbols_path
    else
      flash[:error] = "The secred symbol #{@secred_symbol.name} was NOT added"
      @secred_symbols = SecredSymbol.all
      render :index
    end  
  end

  def edit
    @secred_symbol = SecredSymbol.find_by(slug: params[:id])
    @secred_symbols = SecredSymbol.all
    render :index
  end

  def update
    @secred_symbol = SecredSymbol.find_by(slug: params[:id])
    if @secred_symbol.update_attributes(secred_symbol_params)
      flash[:notice] = "#{@secred_symbol.name} was updated"
      redirect_to admin_secred_symbols_path
    else
      flash[:error] = "#{@secred_symbol.name} was NOT updated"
      @secred_symbols = SecredSymbol.all
      render :index
    end
  end

  def destroy
    secred_symbol = SecredSymbol.find_by(slug: params[:id])
    secred_symbol.delete
    flash[:notice] = "#{secred_symbol.name} was deleted"
    redirect_to admin_secred_symbols_path
  end


  private

  def secred_symbol_params
    params.require(:secred_symbol).permit(:name, :description, :image)
  end

end