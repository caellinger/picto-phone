import React, { useState, useEffect } from 'react'
import { Redirect } from "react-router-dom"

import RoundTile from '../components/RoundTile'
import NewRoundButton from '../components/NewRoundButton'

const RoundsIndexContainer = () => {
  const [rounds, setRounds] = useState([])
  const [user, setUser] = useState({
    id: null,
    userName: null
  })
  const [roundCreated, setRoundCreated] = useState(null)

  let setRoundID = (roundID) => {
    setRoundCreated(roundID)
  }

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
          user={user}
          setRoundID={setRoundID}
        />
      )
    })
  }

  if (roundCreated) {
    return <Redirect to={`/rounds/${roundCreated}`} />
  }

  return (
    <div className="grid-container">
      <div className="grid-x center">
        <NewRoundButton user={user} setRoundID={setRoundID}/>
      </div>
      {roundsTiles}
    </div>
  )
}

export default RoundsIndexContainer
