module ApplicationHelper

  def nav_active(path)
    if current_page?(path)    
      'active'
    else
      ''
    end
  end


  def display_price(amount_in_cents)
    number_to_currency(amount_in_cents/100, :precision => 0)
  end

  def display_date(date)
    #date.to_formatted_s(:long) 
    date.strftime("%d/%m/%Y %l:%M%P") unless !date # 03/14/2013 9:09pm 
  end

  def display_country(country_code)
    Carmen::Country.coded(country_code).name + ' (' + country_code + ')'
  end

  def display_state(country_code, state_code)
    if state_code && Carmen::Country.coded(country_code) && Carmen::Country.coded(country_code).subregions.coded(state_code)
      Carmen::Country.coded(country_code).subregions.coded(state_code).name + ' (' + state_code + ')'
    else
      state_code
    end
  end
end
