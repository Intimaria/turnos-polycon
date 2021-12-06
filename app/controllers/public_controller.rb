class PublicController < ApplicationController
  def home
    # cat_response = RestClient.get('https://aws.random.cat/meow')
    # @cat = eval(cat_response)[:file]
    @name ||= current_user.username
  end

  def all_appointments
    @appointments = Appointment.eager_load(:professional)
  end 

end
