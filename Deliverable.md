### ER Diagrams

See draw.io screenshots.

### User Stories and Acceptance Criteria

First Few User Stories

```
As an unauthenticated user
I want to sign into PictoPhone
So that I can play a game with my friends
```

Acceptance Criteria
* User is able to log in if they fill out all fields
* User is not able to log in if they don't fill out all fields
* User is taken to a page where they see open rounds and a button to start a round

```
As an authenticated user
I want to create a round of PictoPhone
So that my friends can join
```

Acceptance Criteria
* User clicks on a "Create Round" button and is taken to a page where they can see people join their round
* As players join, the user sees their names appear
Will be built in React

```
As an authenticated user
I want to join a round
So that I can play a round with my friends
```

Acceptance Criteria
* User sees a list of open rounds on the index page
* When a user clicks "join", they are taken to a holding page until the round starts

```
As a user who started a round
I want to get a random prompt
So that I can draw it and start the round
```

Acceptance Criteria
* User sees a random prompt from the API

```
As a user who got a prompt
I want to submit a drawing
So that my friends can guess what I drew
```

Acceptance Criteria
* User sees a drawing pad where they can draw the prompt
* User is able to submit the drawing so that it gets passed to the next person

Other User Stories

As a user who created a round
I want to see who joined my round
So that I can start the round

As a user who started a round
I want to get a random prompt
So that I can draw it

As a user who joined a round
I want to see a drawing or guess
So that I can guess the drawing or draw the guess
Note: Is this too much for one user story?

As a user who participated in a round
I want to see the progression of drawings and guesses
So that I can laugh at my friends

### Brief Description (aka Your "Elevator Pitch")

PictoPhone is a combination of Pictionary and Telephone, inspired by the game Telestrations. A player will start a round, and then other players can join. The initial player receives a random word prompt from the Dictionary API, which they draw. The next player sees this drawing, and guesses what the prompt was. The next player sees the second player's guess, and draws it. The next player sees the drawing of the guess, etc. After all players have either drawn or guessed, the series of guesses and drawings are displayed to all users.





https://github.com/szimek/signature_pad
https://github.com/michaeldzjap/react-signature-pad-wrapper
https://www.npmjs.com/package/react-signature-canvas
