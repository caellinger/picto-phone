import React, { useState } from 'react'

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
      <div className="final-text">{props.round.roundPrompt}</div>
      <h3 className="page-title cell small-12">{turnType}</h3>
      <div className="final-text">{response}</div>
    </div>
  )
}

export default ConclusionComponent
