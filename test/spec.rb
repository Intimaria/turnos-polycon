require 'minitest/autorun'
require_relative '../lib/polycon/model/appointment'
require_relative '../lib/polycon/model/professional'
require_relative '../lib/polycon/store'

describe 'Polycon' do
  before do
    @professional = Polycon::Model::Professional.create(name: 'John Doe')
    @appointment1 = Polycon::Model::Appointment.create(
      date: '2021-01-01 11:30',
      professional: 'John Doe',
      name: 'Jane',
      surname: 'J',
      phone: '111111111',
      notes: 'Something'
    )
    @appointment2 = Polycon::Model::Appointment.create(
      date: '2021-01-01 12:30',
      professional: 'John Doe',
      name: 'Jane',
      surname: 'J',
      phone: '111111111',
      notes: 'Something'
    )

    @appointment1.save unless Polycon::Store.exist_appointment?(@appointment1)
    @appointment2.save unless Polycon::Store.exist_appointment?(@appointment2)
  end

  # Store
  it 'returns path for polycon' do
    expect(Polycon::Store.root).must_equal "#{Dir.home}/.polycon/"
  end
  it 'returns path for professional' do
    expect(Polycon::Store.professional_path(@professional)).must_equal 'JOHN_DOE/'
  end
  it 'returns path for appointment' do
    expect(Polycon::Store.appointment_path(@appointment1)).must_equal 'JOHN_DOE/2021-01-01_11-30.paf'
  end
  it 'returns the array of appointment variables' do
    expect(Polycon::Store.read(professional: @appointment1.professional,
                               date: @appointment1.date)).must_equal ["J", "Jane", "111111111",
                                                                      "Something"]
  end
  it 'returns all the appointment for a professional as a string array of dates' do
    expect(Polycon::Store.all_appointment_dates_for_prof(@professional)).must_equal ["2021-01-01 11:30",
                                                                                     "2021-01-01 12:30"]
  end
  it 'returns true if the professional has appointments' do
    expect(Polycon::Store.has_appointments?(@professional)).must_equal true
  end
  it 'returns true if the professional exists' do
    expect(Polycon::Store.exist_professional?(@professional)).must_equal true
  end
  it 'returns true if the appointment exists' do
    expect(Polycon::Store.exist_appointment?(@appointment1)).must_equal true
  end

  # Appointment
  it 'returns all the appointment for a professional as an array of appointments' do
    expect(Polycon::Model::Appointment.all_for_professional(@professional)).must_be_instance_of Array
  end
  it 'returns all the appointments' do
    expect(Polycon::Model::Appointment.all).must_be_instance_of Array
  end
  it 'returns the name of the appointment as string' do
    expect(@appointment1.to_s).must_equal ["professional: John Doe", "date: 2021-01-01", "hour: 11:30", "surname: J",
                                           "name: Jane", "phone: 111111111", "notes: Something"]
  end

  # Professional
  it 'returns the name of the professional as string' do
    expect(@professional.to_s).must_equal "John Doe"
  end
  it 'returns all the appointment for a professional as a string array of dates' do
    expect(@professional.appointments).must_be_instance_of Array
  end
  it 'returns true if the professional has appointments' do
    expect(@professional.appointments?).must_equal true
  end
  it 'returns a hash with name and surname' do
    expect(@professional.to_h).must_be_instance_of Hash
  end
end
