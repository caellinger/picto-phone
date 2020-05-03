import React from 'react'
import { Redirect } from "react-router-dom"

const NewRoundButton = (props) => {
  let newRoundClick = (event) => {
    event.preventDefault()
    let round = {
      starter_name: props.user.userName
    }
    fetch("/api/v1/rounds", {
        credentials: "same-origin",
        method: "POST",
        body: JSON.stringify(round),
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
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
      let participant = {
        round_id: body.round.id,
        user_id: props.user.id,
        participant_type: "drawer",
        round_starter: true
      }
      fetch("/api/v1/participants", {
        credentials: "same-origin",
        method: "POST",
        body: JSON.stringify(participant),
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
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
        props.setRoundID(body.participant.round_id)
      })
      .catch((error) => console.error(`Error in fetch: ${error.message}`))
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }

  let newRoundButton
  if (props.user.id) {
    newRoundButton = <input
      type="submit"
      className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"
      value="Start New Round"
      onClick={newRoundClick}
    />
  } else {
    newRoundButton = <></>
  }

  return (
    <>
      {newRoundButton}
    </>
  )
}

export default NewRoundButton
