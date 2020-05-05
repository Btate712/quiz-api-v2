
p = Project.create(name: "Dummy Data")

topics = [
  Topic.create(name: "Math", project_id: p.id), 
  Topic.create(name: "Science", project_id: p.id), 
  Topic.create(name: "Spanish", project_id: p.id)
]


questions = [
  Question.new(stem: "What is 2 + 2?", choice_1: "1", choice_2: "2",
    choice_3: "3", choice_4: "4", correct_choice: "4",
    topic: Topic.find_by(name: "Math")),
  Question.new(stem: "What is 2 + 3", choice_1: "4", choice_2: "5",
    choice_3: "6", choice_4: "7", correct_choice: "2",
    topic: Topic.find_by(name: "Math")),
  Question.new(stem: "What is the symbol for Oxygen?", choice_1: "O",
     choice_2: "Ox", choice_3: "Og", choice_4: "On", correct_choice: "1",
     topic: Topic.find_by(name: "Science")),
  Question.new(stem: "How many meters in a km?", choice_1: "100",
    choice_2: "1000", choice_3: "10000", choice_4: "100000",
    correct_choice: "2", topic: Topic.find_by(name: "Science")),
  Question.new(stem: "How do you say 'large' in Spanish?", choice_1: "largeo",
    choice_2: "pequeno", choice_3: "grande", choice_4: "biggo",
    correct_choice: "3", topic: Topic.find_by(name: "Spanish")),
  Question.new(stem: "What does 'estrella' mean in English?",
    choice_1: "street", choice_2: "extra", choice_3: "strange",
    choice_4: "star", correct_choice: "4", topic: Topic.find_by(name: "Spanish"))]

questions.each { |question| question.save }

User.create(name: "temp", password: "temp", email: "temp@temp.temp", is_admin: false)
User.create(name: "temp2", password: "temp2", email: "temp2@temp.temp", is_admin: false)
User.create(name: "admin", password: "admin", email: "admin@admin.admin", is_admin: true)

UserProject.create(user: User.find_by(name: "temp2"), project: Project.find_by(name: "Dummy Data"), access_level: 30)