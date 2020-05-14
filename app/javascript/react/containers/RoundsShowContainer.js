import React, { useState, useEffect } from 'react'

import RoundWaitingComponent from '../components/RoundWaitingComponent'
import RoundInProgressComponent from '../components/RoundInProgressComponent'
import DrawingComponent from '../components/DrawingComponent'
import GuessingComponent from '../components/GuessingComponent'
import ConclusionComponent from '../components/ConclusionComponent'

const RoundsShowContainer = (props) => {
  const [round, setRound] = useState({
    id: null,
    starterName: null,
    status: "waiting",
    turn: 0,
    turnUserID: null,
    roundPrompt: null,
    currentPrompt: null
  })
  const [players, setPlayers] = useState([])
  const [user, setUser] = useState({
    id: null,
    userName: null
  })

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
        starterName: body.round.starter_name,
        status: body.round.status,
        turn: body.round.turn,
        turnUserID: body.round.turn_user_id,
        roundPrompt: body.round.round_prompt,
        currentPrompt: body.round.current_prompt
      })
      setPlayers(body.round.participants.participants)
      setUser(body.round.current_user)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))

    App.roundChannel = App.cable.subscriptions.create(
      {
        channel: "RoundChannel",
        round_id: props.match.params.id
      },
      {
        connected: () => console.log("RoundChannel connected"),
        disconnected: () => console.log("RoundChannel disconnected"),
        received: data => {
          setRound(data)
        }
      }
    )
  }, [])

  function updateStatusInProgress(payload) {
    App.roundChannel.send(payload)
  }

  function submitDrawing(payload) {
    App.roundChannel.send(payload)
  }

  function submitGuess(payload) {
    App.roundChannel.send(payload)
  }

  let renderComponent
  if (round["status"] == "waiting") {
    renderComponent = <RoundWaitingComponent
      players={players}
      user={user}
      round={round}
      updateStatusInProgress={updateStatusInProgress}
    />
  } else if (round["status"] == "in progress" && round["turnUserID"] == user.id && round["turn"] % 2 == 0) {
      renderComponent = <DrawingComponent
        user={user}
        round={round}
        submitDrawing={submitDrawing}
      />
    } else if (round["status"] == "in progress" && round["turnUserID"] == user.id && round["turn"] % 2 != 0) {
      renderComponent = <GuessingComponent
        user={user}
        round={round}
        submitGuess={submitGuess}
      />
    } else if (round["status"] == "in progress" && round["turnUserID"] != user.id) {
      renderComponent = <RoundInProgressComponent
      />
    } else {
      renderComponent = <ConclusionComponent
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
