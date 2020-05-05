import React, { useState, useEffect } from 'react'

import ParticipantTile from '../components/ParticipantTile'

const RoundsShowContainer = (props) => {
  // if starter hasn't clicked start button yet, show list of users in round
  // if user is the starter, show the start button
  // when starter clicks start button, api call to get prompt, show prompt and drawing pad
  const [round, setRound] = useState({
    id: null,
    starterName: null,
  })
  const [players, setPlayers] = useState([])
  const [user, setUser] = useState({
    id: null,
    userName: null
  })
  const [shouldRedirect, setShouldRedirect] = useState(false)

  useEffect(() => {
    const id = props.match.params.id
    fetch(`/api/v1/rounds/${id}`)
    .then((response) => {
      if (response.ok) {
        return response
      } else {
        let errorMessage = `${response.status} (${response.statusText})`
        let error = new Error(errorMessage)
        throw error
      }
    })
    .then((response) => {
      return response.json()
    })
    .then((body) => {
      setRound({
        id: body.round.id,
        starterName: body.round.starter_name
      })
      setPlayers(body.round.participants.participants)
      setUser(body.round.current_user)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }, [])

  let playerList
  if (players.length > 0) {
    playerList = players.map(player => {
      return (
        <ParticipantTile
          key={player.id}
          participant={player}
          />
      )
    })
  }

  let startButton
  if (user.userName == round.starterName && user.userName != null) {
    startButton =
      <input
        type="submit"
        className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"
        value="Start Round"
      />
  } else {
    startButton =
      <div className="cell small-8 small-offset-2 align-middle align-center waiting">
        Waiting for the host to start the game
      </div>
  }

  let clickStart = (event) => {
    event.preventDefault
  }

  return (
    <div>
      <h3 className="page-title">Players</h3>
      <div className="grid-container">
        {playerList}
        <div className="grid-x center">
          {startButton}
        </div>
      </div>
    </div>
  )
}

export default RoundsShowContainer
