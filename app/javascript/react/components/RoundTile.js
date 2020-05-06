import React from 'react'

const RoundTile = (props) => {
  let clickJoin = (event) => {
    event.preventDefault()
    let participant = {
      round_id: props.round.id,
      user_id: props.user.id,
      participant_type: "guesser",
      round_starter: "false"
    }
    fetch("/api/v1/participants", {
      credentials: "same-origin",
      method: "POST",
      body: JSON.stringify(participant),
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
      props.setRoundID(body.participant.round_id)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }

  return (
    <div className="tile grid-x grid-margin-x align-middle">
      <div className="cell small-12 medium-10 tile-margins tile-text">{props.round.starter_name}</div>
      <input
        type="submit"
        className="cell small-12 medium-2 align-middle tile-margins custom-button"
        value="Join"
        onClick={clickJoin}
      />
    </div>
  )
}

export default RoundTile
