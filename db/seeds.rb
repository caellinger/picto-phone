# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
User.create(email: "c.a.ellinger+1@gmail.com", user_name: "Christie1", password: "password")
User.create(email: "c.a.ellinger+2@gmail.com", user_name: "Christie2", password: "password")

Round.create(starter_name: "Christie1")
Round.create(starter_name: "Christie2")

Participant.create(round: Round.first, user: User.first, order_id: 1, participant_type: "drawer", round_starter: true)
Participant.create(round: Round.first, user: User.second, order_id: 2, participant_type: "guesser", round_starter: false)

Participant.create(round: Round.second, user: User.second, order_id: 3, participant_type: "drawer", round_starter: true)
Participant.create(round: Round.second, user: User.first, order_id: 4, participant_type: "guesser", round_starter: false)
