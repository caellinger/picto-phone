import React from 'react'

const RoundTile = (props) => {
  let clickJoin = (event) => {
    event.preventDefault()
    let payload = {
      round_id: props.round.id,
      user_id: props.user.id,
      round_starter: "false"
    }
    let endpoint = "/api/v1/participants"
    props.joinRound(payload, endpoint)
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
