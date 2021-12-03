class PublicController < ApplicationController

    def home 
        @name ||= current_user.username 
    end
end