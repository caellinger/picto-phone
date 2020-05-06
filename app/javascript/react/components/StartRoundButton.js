import React from 'react'
import { Redirect } from "react-router-dom"

const StartRoundButton = (props) => {
  let clickStart = (event) => {
    event.preventDefault()
    fetch(`/api/v1/rounds/${props.round.id}`, {
      credentials: "same-origin",
      method: 'PATCH',
      body: JSON.stringify({
        status: "in progress" // ,
        // prompt: "elephant",
        // turn: true
      }),
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .then(response => {
      if (response.ok) {
        console.log("ok")
      } else {
        let errorMessage = `${response.status} (${response.statusText})`
        let error = new Error(errorMessage)
        throw error
      }
    })
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
