import React, { useState, useEffect } from 'react'

import ParticipantTile from '../components/ParticipantTile'
import StartRoundButton from '../components/StartRoundButton'

const RoundWaitingComponent = (props) => {
  let playerList
  if (props.players.length > 0) {
    playerList = props.players.map(player => {
      return (
        <ParticipantTile
          key={player.id}
          participant={player}
          />
      )
    })
  }

  return (
    <div>
      <h3 className="page-title">Players</h3>
      <div className="grid-container">
        {playerList}
        <div className="grid-x center">
          <StartRoundButton
            user={props.user}
            round={props.round}
            updateStatusInProgress={props.updateStatusInProgress}
            />
        </div>
      </div>
    </div>
  )
}

export default RoundWaitingComponent
