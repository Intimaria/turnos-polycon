class PublicController < ApplicationController

    def home 
        if current_user
        @name ||= (current_user.username)
        end 
    end
end