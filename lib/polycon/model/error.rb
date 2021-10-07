module Polycon
  module Model 
    class Error < StandardError; end 



    class NotFound < Error 
      def message
        "What you are looking for is not to be found"
      end
    end
  
    class AlreadyExists <Error
      def message
        "What you wish to create already exists"
      end
    end 
  end 
end 