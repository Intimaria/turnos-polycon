require 'minitest/autorun'
require_relative '../lib/polycon/model/appointment'
require_relative '../lib/polycon/model/professional'
describe 'Appointment' do 
    before do
        @professional = Professional.new(name: "John Doe")
        @appointment1 = Appointment.new(
                                        date: "2021-01-01", 
                                        professional: "John Doe", 
                                        name: "Jane", 
                                        surname: "J", 
                                        phone: "111111111",
                                        notes: "Something") 
        @appointment2 = Appointment.new(
                                        date: "2021-01-01", 
                                        professional: "John Doe", 
                                        name: "Jane", 
                                        surname: "J", 
                                        phone: "111111111",
                                        notes: "Something") 
    end
    it "returns a range of appointments for a professional" do 
       Appointment.all(professional: @professional).must_equal [@appointment1, @appointment2]
    end 
end 