require 'minitest/autorun'
require_relative '../lib/polycon/model/appointment'
require_relative '../lib/polycon/model/professional'
require_relative '../lib/polycon/store'

describe 'Store' do
  before do
    @professional = Polycon::Model::Professional.create(name: 'John Doe')
    @appointment1 = Polycon::Model::Appointment.create(
                                        date: '2021-01-01 11:30',
                                        professional: 'John Doe',
                                        name: 'Jane',
                                        surname: 'J',
                                        phone: '111111111',
                                        notes: 'Something')
    @appointment2 = Polycon::Model::Appointment.create(
                                        date: '2021-01-01 12:30',
                                        professional: 'John Doe',
                                        name: 'Jane',
                                        surname: 'J',
                                        phone: '111111111',
                                        notes: 'Something')
    
    @appointment1.save unless Polycon::Store.exist_appointment?(@appointment1)
    @appointment2.save unless Polycon::Store.exist_appointment?(@appointment2)
  end
  it 'returns path for polycon' do
    Polycon::Store.root.must_equal "#{Dir.home}/.polycon/"
  end
  it 'returns path for professional' do 
    Polycon::Store.professional_path(@professional).must_equal 'JOHN_DOE/'
  end
  it 'returns path for appointment' do 
    Polycon::Store.appointment_path(@appointment1).must_equal 'JOHN_DOE/2021-01-01_11-30.paf'
  end
  it 'returns array of appointment variables' do 
    Polycon::Store.read(professional:@appointment1.professional,date:@appointment1.date).must_equal ["J", "Jane", "111111111", "Something"]
  end
end

