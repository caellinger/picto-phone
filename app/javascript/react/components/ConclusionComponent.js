import React, { useState } from 'react'
import { Link } from 'react-router-dom'

const ConclusionComponent = (props) => {
  let turnType
  let response
  if (props.round.turn % 2 == 1) {
    turnType = "Final Drawing"
    response = <img
      src={props.round.currentPrompt}
      alt="drawing"
    />
  } else {
    turnType = "Final Guess"
    response = props.round.currentPrompt
  }

  return (
    <div className="grid-x">
      <h3 className="page-title cell small-12">Starting Prompt</h3>
      <div className="cell small-12 final-text">{props.round.roundPrompt}</div>
      <h3 className="page-title cell small-12">{turnType}</h3>
      <div className="cell small-12 align-middle align-center final-text">{response}</div>

        <p className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"><Link to="/">Go Home</Link></p>

    </div>
  )
}

export default ConclusionComponent
