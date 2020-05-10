import React, { useState, useEffect } from 'react'

import RoundWaitingComponent from '../components/RoundWaitingComponent'
import RoundInProgressComponent from '../components/RoundInProgressComponent'
import DrawingComponent from '../components/DrawingComponent'

const RoundsShowContainer = (props) => {
  const [round, setRound] = useState({
    id: null,
    starterName: null,
  })
  const [players, setPlayers] = useState([])
  const [user, setUser] = useState({
    id: null,
    userName: null
  })
  const [status, setStatus] = useState("waiting")
  const [turn, setTurn] = useState(0)
  const [turnUserID, setTurnUserID] = useState(null)
  const [roundPrompt, setRoundPrompt] = useState(null)
  const [currentPrompt, setCurrentPrompt] = useState(null)

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
      setStatus(body.round.status)
      setTurn(body.round.turn)
      setTurnUserID(body.round.turn_user_id)
      if (body.round.round_prompt) {
        setRoundPrompt(body.round.round_prompt)
      }
      if (body.round.current_prompt) {
        setCurrentPrompt(body.round.current_prompt)
      }
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }, [])

  function fetchPost(payload, endpoint, method) {
    fetch(endpoint, {
      credentials: "same-origin",
      method: method,
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
    .then((response) => {
      return response.json()
    })
    .then((body) => {
      if (body.round.status) {
        setStatus(body.round.status)
      }
      if (body.round.turn) {
        setTurn(body.round.turn)
      }
      if (body.round.turn_user_id) {
        setTurnUserID(body.round.turn_user_id)
      }
      if (body.round.round_prompt) {
        setRoundPrompt(body.round.round_prompt)
      }
      if (body.round.current_prompt) {
        setCurrentPrompt(body.round.current_prompt)
      }
    })
  }

  function updateStatusInProgress(payload, endpoint) {
    fetchPost(payload, endpoint, 'PATCH')
  }

  function submitDrawing(payload, endpoint) {
    fetchPost(payload, endpoint, 'POST')
  }

  let renderComponent
    if (status == "waiting") {
      renderComponent = <RoundWaitingComponent
        players={players}
        user={user}
        round={round}
        updateStatusInProgress={updateStatusInProgress}
      />
    } else if (status == "in progress" && turnUserID == user.id && turn % 2 == 0) {
      renderComponent = <DrawingComponent
        user={user}
        round={round}
        currentPrompt={currentPrompt}
        submitDrawing={submitDrawing}
      />
    } else if (status == "in progress" && turnUserID == user.id && turn % 2 != 0) {
      renderComponent = <div>Guessing</div>
    } else {
      renderComponent = <RoundInProgressComponent
      />
    }

  return (
    <div>
      {renderComponent}
    </div>
  )
}

export default RoundsShowContainer
