# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
User.create(email: "c.a.ellinger+1@gmail.com", user_name: "Christie1", password: "password")
User.create(email: "c.a.ellinger+2@gmail.com", user_name: "Christie2", password: "password")

Round.create(starter_name: "Christie1", turn_user_id: User.find_by(user_name: "Christie1").id)
Round.create(starter_name: "Christie2", turn_user_id: User.find_by(user_name: "Christie2").id)

Participant.create(round: Round.first, user: User.first, participant_type: "drawer", round_starter: true)
Participant.create(round: Round.first, user: User.second, participant_type: "guesser", round_starter: false)

Participant.create(round: Round.second, user: User.second, participant_type: "drawer", round_starter: true)
Participant.create(round: Round.second, user: User.first, participant_type: "guesser", round_starter: false)
