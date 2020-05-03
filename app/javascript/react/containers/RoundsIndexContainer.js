import React, { useState, useEffect } from 'react'

import RoundTile from '../components/RoundTile'

const RoundsIndexContainer = () => {
  const [rounds, setRounds] = useState([])
  const [user, setUser] = useState({
    id: null,
    userName: null
  })

  useEffect(() => {
    fetch("/api/v1/rounds")
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
      setRounds(body.rounds)
      setUser(body.rounds[0].user)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }, [])

  let roundsTiles
  if (rounds.length < 1) {
    roundsTiles = "No active games"
  } else {
    roundsTiles = rounds.map(round => {
      return (
        <RoundTile
          key={round.id}
          round={round}
        />
      )
    })
  }

  let newRoundButton
  if (user.id) {
    newRoundButton = <input type="submit" className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center" value="Start New Round"/>
  } else {
    newRoundButton = <></>
  }

  return (
    <div className="grid-container">
      <div className="grid-x center">
        {newRoundButton}
      </div>
      {roundsTiles}
    </div>
  )
}

export default RoundsIndexContainer
