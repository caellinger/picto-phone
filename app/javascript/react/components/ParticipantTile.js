import React from 'react'

const ParticipantTile = (props) => {
  return (
    <div className="tile grid-x grid-margin-x align-middle">
      <div className="cell small-12 medium-10 tile-margins tile-text">
        {props.participant.user_name}
      </div>
    </div>
  )
}

export default ParticipantTile
