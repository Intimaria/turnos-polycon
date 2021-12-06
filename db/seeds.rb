NUM_PROFESSIONALS = 10
RANGE_APPOINTMENTS = (2..7)

User.destroy_all
Appointment.destroy_all
Professional.destroy_all

admin = User.create(email: 'admin@admin.com', username: "Admin", password: '123456')
admin.admin!
manager = User.create(email: 'manager@manager.com', username: "Manager", password: '123456')
manager.manager!
user = User.create(email: 'user@user.com', username: "User", password: '123456')
user.user!

# Professionals
p_names = ["Lisandro", "Armando", "Denise", "Anna", "Paula"]
p_surnames = ["Rodriguez", "Randall", "Lopez", "Medellin", "Cortazar"]
p_titles = ["Lic.", "Dr.", "Ing."]

def make_professional(name, surname, title)
  Professional.create(
    {
      title: title.sample,
      name: name.sample,
      surname: surname.sample,
    }
  )
end

NUM_PROFESSIONALS.times do
  make_professional(p_names, p_surnames, p_titles)
end

# Appointments

a_names = ["Juan", "Maria", "Carla", "Pablo"]
a_surnames = ["Donda", "Redis", "Pampa", "Suarez"]

nums = (0..9).to_a
a_phones = []
10.times do
  a_phones.push("0221-" + (0...7).map { [rand(nums.length)] }.join)
end

response = RestClient.get('https://loripsum.net/api/10/plaintext')
a_notes = response.body.split("\n")
a_notes.reject! { |item| item.blank? }

a_professionals = Professional.pluck(:id)
def make_appointments(professional, names, surnames, phones, notes, date, time)
  Appointment.create(
    {
      professional_id: professional,
      name: names.sample,
      surname: surnames.sample,
      phone: phones.sample,
      notes: notes.sample,
      date: date,
      time: time
    }
  )
end

a_professionals.each do |prof|
  rand(RANGE_APPOINTMENTS).times do |i|
    date = rand(1.months.from_now..4.months.from_now)
    time = Time.new(date.year, date.month, date.day).change(hour: 8 + i)
    make_appointments(prof, a_names, a_surnames, a_phones, a_notes, date, time)
  end
end
