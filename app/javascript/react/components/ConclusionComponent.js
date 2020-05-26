import React, { useState } from 'react'
import { Link } from 'react-router-dom'

import FullSequenceComponent from './FullSequenceComponent'

const ConclusionComponent = (props) => {
  const [showSequence, setShowSequence] = useState(false)

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

  let clickMore = (event) => {
    event.preventDefault()
    setShowSequence(true)
  }

  let clickLess = (event) => {
    event.preventDefault()
    setShowSequence(false)
  }

  if (showSequence) {
    return (
      <div className="grid-x">
        <h3 className="page-title cell small-12">Starting Prompt</h3>
        <div className="cell small-12 final-text">{props.round.roundPrompt}</div>

        <div className="cell small-12 align-middle align-center see-more-text">
          <button onClick={clickLess}><i className="fas fa-chevron-up"/>see less</button>
        </div>

        <FullSequenceComponent
          initialPrompt = {props.round.roundPrompt}
          roundID = {props.round.id}
        />

        <div className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"><Link to="/">Go Home</Link></div>
      </div>
    )
  } else {
    return (
      <div className="grid-x">
        <h3 className="page-title cell small-12">Starting Prompt</h3>
        <div className="cell small-12 final-text">{props.round.roundPrompt}</div>

        <div className="cell small-12 align-middle align-center see-more-text">
          <button onClick={clickMore}><i className="fas fa-chevron-down"/>see more</button>
        </div>

        <h3 className="page-title cell small-12">{turnType}</h3>
        <div className="cell small-12 align-middle align-center final-text">{response}</div>

        <div className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"><Link to="/">Go Home</Link></div>
      </div>
    )
  }
}

export default ConclusionComponent
