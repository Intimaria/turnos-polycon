# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all 
Appointment.destroy_all
Professional.destroy_all


u = User.create(email: 'admin@admin.com', username: "Inti", password: '123456')
u.admin!

# Professionals 
p_names = ["Lisandro", "Armando", "Denise", "Anna", "Paula"]
p_surnames = ["Rodriguez", "Randall", "Lopez", "Medellin", "Cortazar"]
p_titles = ["Lic.", "Dr.", "Ing."]

def make_professional(names, surnames, titles)
    Professional.create(
        {
            title: titles.sample,
            name: names.sample,
            surname: surnames.sample,
        }
    )
end

num_professionals = 10 

num_professionals.times do 
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
def make_appointments(professional, names, surnames, phones, notes, date)
    Appointment.create(
        {
            professional_id: professional,
            name: names.sample,
            surname: surnames.sample,
            phone: phones.sample,
            notes: notes.sample,
            date: date
        }
        )
end 

a_professionals.each do | prof |
    rand(2..7).times do | i |
        date = rand(1.months.from_now..4.months.from_now).change(hour: 8 + i)
        make_appointments(prof, a_names, a_surnames, a_phones, a_notes, date)
    end 
end 