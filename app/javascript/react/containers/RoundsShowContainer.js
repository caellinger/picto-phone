import React, { useState, useEffect } from 'react'

import RoundWaitingComponent from '../components/RoundWaitingComponent'

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
  }

  return (
    <div>
      {renderComponent}
    </div>
  )
}

export default RoundsShowContainer
