import React, { useState, useEffect } from 'react'

import ParticipantTile from '../components/ParticipantTile'

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

  let startButton
  if (props.user.userName == props.round.starterName && props.user.userName != null) {
    startButton =
      <input
        type="submit"
        className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"
        value="Start Round"
      />
  } else {
    startButton =
      <div className="cell small-8 small-offset-2 align-middle align-center waiting">
        Waiting for the host to start the game
      </div>
  }

  let clickStart = (event) => {
    event.preventDefault
  }

  return (
    <div>
      <h3 className="page-title">Players</h3>
      <div className="grid-container">
        {playerList}
        <div className="grid-x center">
          {startButton}
        </div>
      </div>
    </div>
  )
}

export default RoundWaitingComponent
