import React from 'react'
import { Redirect } from "react-router-dom"

const NewRoundButton = (props) => {
  let newRoundClick = (event) => {
    event.preventDefault()
    let payload = {
      starter_name: props.user.userName,
      turn_user_id: props.user.id,
      user_id: props.user.id,
      round_starter: true
    }
    let endpoint = "/api/v1/rounds"
    props.createRound(payload, endpoint)
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
