class PublicController < ApplicationController
  def home
    # cat_response = RestClient.get('https://aws.random.cat/meow')
    # @cat = eval(cat_response)[:file]
    @name ||= current_user.username
  end

  def all_appointments
    @appointments = Appointment.eager_load(:professional).paginate(:page => params[:page], per_page:5)
  end 

end
