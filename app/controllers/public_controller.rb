class PublicController < ApplicationController
  def home
    # cat_response = RestClient.get('https://aws.random.cat/meow')
    # @cat = eval(cat_response)[:file]
    @name ||= current_user.username
  end

  def all_appointments
    @appointments = Appointment.search(params[:search])
  end 

end
