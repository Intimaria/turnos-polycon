module ProfessionalsHelper
  def full_name(professional)
    "#{professional.title} #{professional.name.first} #{professional.surname}"
  end
end
