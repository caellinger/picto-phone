import React from 'react'
import { Redirect } from "react-router-dom"

const StartRoundButton = (props) => {
  let clickStart = (event) => {
    event.preventDefault()
    let payload = {
      round_id: props.round.id,
      status: "in progress",
      participant_type: "drawer",
      prompt: "elephant" // TODO: REMOVE ONCE WORDS API IS CONNECTED
    }
    let endpoint = `/api/v1/rounds/${props.round.id}`
    props.updateStatusInProgress(payload, endpoint)
  }

  let startRoundButton
  if (props.user.userName == props.round.starterName && props.user.userName != null) {
    startRoundButton =
      <input
        type="submit"
        className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"
        value="Start Round"
        onClick={clickStart}
      />
  } else {
    startRoundButton =
      <div className="cell small-8 small-offset-2 align-middle align-center waiting">
        Waiting for the host to start the game
      </div>
  }

  return (
    <>
      {startRoundButton}
    </>
  )
}

export default StartRoundButton
