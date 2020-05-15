import React, { useState, useEffect } from 'react'
import { Redirect } from "react-router-dom"
import { _ } from "lodash"

import RoundTile from '../components/RoundTile'
import NewRoundButton from '../components/NewRoundButton'

const RoundsIndexContainer = () => {
  const [rounds, setRounds] = useState([])
  const [user, setUser] = useState({
    id: null,
    user_name: null
  })
  const [round, setRound] = useState(null)
  const [busy, setBusy] = useState(false)
  const [joinError, setJoinError] = useState(false)

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
      setUser(body.current_user)
      if (body.capped) {
        setBusy(true)
      }
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
      debugger
      if (body.busy) {
        setBusy(true)
      } else if (body.round) {
        setRound(body.round.id)
      } else {
        setRounds(body.rounds)
        setJoinError(true)
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

  let busyMessage
  let newRoundButtonColor
  let joinRoundButtonColor
  let roundsTiles
  let errorMessage

  if (busy && user.id) {
    newRoundButtonColor = "gray-button"
    busyMessage = <p className="cell small-12 error-text">Too many rounds in progress, please try again in a few minutes</p>
  } else if (user.id) {
    newRoundButtonColor = "custom-button"
    busyMessage = <></>
  } else {
    newRoundButtonColor = "gray-button"
    busyMessage = <p className="cell small-12 error-text">Please log in to start or join a round</p>
  }

  if (user.id) {
    joinRoundButtonColor = "custom-button"
  } else {
    joinRoundButtonColor = "gray-button"
  }

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
          joinRoundButtonColor = {joinRoundButtonColor}
        />
      )
    })
  }

  if (joinError) {
    errorMessage = <p className="callout alert cell small-12 error-text">Too many players in that round, please choose a different one</p>
  } else {
    <></>
  }

  if (round) {
    return <Redirect to={`/rounds/${round}`} />
  }

  return (
    <div className="grid-container">
      {errorMessage}
      <div className="grid-x center">
        <NewRoundButton
          user={user}
          setRound={setRound}
          createRound={createRound}
          roundCount={rounds.length}
          newRoundButtonColor={newRoundButtonColor}
        />
        {busyMessage}
      </div>
      {roundsTiles}
    </div>
  )
}

export default RoundsIndexContainer
