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
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }, [])

  let renderComponent
  if (status == "waiting") {
    renderComponent =
      <RoundWaitingComponent
        players={players}
        user={user}
        round={round}
      />
  } else if (status == "in progress" && turnUserID == user.id && turn % 2 == 0) {
    renderComponent =
      <DrawingComponent
        user={user}
        round={round}
      />
  } else {
    renderComponent =
      <RoundInProgressComponent />
  }

  return (
    <div>
      {renderComponent}
    </div>
  )
}

export default RoundsShowContainer
