import React from 'react'

const RoundTile = (props) => {
  return (
    <div className="tile grid-x grid-margin-x align-middle">
      <div className="cell small-12 medium-10 tile-margins tile-text">{props.round.user_name}</div>
      <input type="submit" className="cell small-12 medium-2 align-middle tile-margins custom-button" value="Guess"/>
    </div>
  )
}

export default RoundTile