import React, { useState } from 'react'
import SignatureCanvas from 'react-signature-canvas'

const DrawingComponent = (props) => {
  let submitHandler = (event) => {
    event.preventDefault()

    if (this.sigCanvas.isEmpty()) {
      alert("You can't submit an empty drawing!");
    } else {
      let payload = {
        drawing: `${this.sigCanvas.toDataURL("image/jpeg")}`,
        user_id: props.user.id,
        round_id: props.round.id //,
        // turn: true
      }
      let endpoint = "/api/v1/drawings"
      props.submitDrawing(payload, endpoint)
      this.sigCanvas.clear()
    }
  }

  return (
    <div className="grid-x">
      <div>
        Your prompt is: {props.currentPrompt}
      </div>
      <div className="sig-pad-container cell small-12">
        <SignatureCanvas
          ref={(ref) => { this.sigCanvas = ref }}
          backgroundColor='#f2f2eb'
        />
      </div>
      <input
        type="submit"
        className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"
        value="Submit"
        onClick={submitHandler}
      />
    </div>
  )
}

export default DrawingComponent
