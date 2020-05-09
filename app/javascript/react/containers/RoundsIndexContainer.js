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
  const [round, setRound] = useState(null)

  let setRoundID = (roundID) => {
    setRound(roundID)
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
      setUser(body.rounds[0].current_user)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }, [])

  function fetchPost(payload, endpoint) {
    fetch(endpoint, {
      credentials: "same-origin",
      method: "POST",
      body: JSON.stringify({ payload }),
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .then(response => {
      if (response.ok) {
        return response
      } else {
        let errorMessage = `${response.status} (${response.statusText})`
        let error = new Error(errorMessage)
        throw error
      }
    })
    .then(response => response.json())
    .then(body => {
      setRoundID(body.participant.round_id)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }

  function joinRound(payload, endpoint) {
    fetchPost(payload, endpoint)
  }

  function createRound(payload, endpoint) {
    fetchPost(payload, endpoint)
  }

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
          joinRound={joinRound}
        />
      )
    })
  }

  if (round) {
    return <Redirect to={`/rounds/${round}`} />
  }

  return (
    <div className="grid-container">
      <div className="grid-x center">
        <NewRoundButton
          user={user}
          setRoundID={setRoundID}
          createRound={createRound}
        />
      </div>
      {roundsTiles}
    </div>
  )
}

export default RoundsIndexContainer
