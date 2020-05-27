import React, { useState } from 'react'

const ResponseComponent = (props) => {
  if (props.participant.participant_type == "drawer") {
    return (
      <div>
        <h3 className="page-title cell small-12">{props.participant.user_name} drew</h3>
        <p className="cell small-12 align-middle align-center final-text">
          <img
            src={props.participant.response}
            alt="drawing"
          />
        </p>
      </div>
    )
  } else {
    return (
      <div>
        <h3 className="page-title cell small-12">{props.participant.user_name} guessed</h3>
        <p className="cell small-12 align-middle align-center final-text">{props.participant.response}</p>
      </div>
    )
  }
}

export default ResponseComponent
