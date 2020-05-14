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
  const [busy, setBusy] = useState(false)

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
      if (body.busy) {
        setBusy(body.busy)
      } else {
        setRoundID(body.round.id)
      }
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

  let newRoundButtonColor
  let busyMessage
  if (busy || rounds.length > 1) {
    newRoundButtonColor = "gray-button"
    busyMessage = <p className="cell small-12 error-text">Too many rounds in progress, please try again in a few minutes</p>
  } else {
    newRoundButtonColor = "custom-button"
    busyMessage = <></>
  }

  return (
    <div className="grid-container">
      <div className="grid-x center">
        <NewRoundButton
          user={user}
          setRoundID={setRoundID}
          createRound={createRound}
          roundCount={rounds.length}
          busy={busy}
          newRoundButtonColor={newRoundButtonColor}
        />
        {busyMessage}
      </div>
      {roundsTiles}
    </div>
  )
}

export default RoundsIndexContainer
