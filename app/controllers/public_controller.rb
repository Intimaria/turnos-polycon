class PublicController < ApplicationController
  def home
    # cat_response = RestClient.get('https://aws.random.cat/meow')
    # @cat = eval(cat_response)[:file]
    @name ||= current_user.username
  end
end
