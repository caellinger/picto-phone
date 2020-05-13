import React, { useState } from 'react'
import SignatureCanvas from 'react-signature-canvas'

const DrawingComponent = (props) => {
  let clearCanvas = (event) => {
    event.preventDefault()

    this.sigCanvas.clear()
  }

  let submitHandler = (event) => {
    event.preventDefault()

    if (this.sigCanvas.isEmpty()) {
      alert("You can't submit an empty drawing!");
    } else {
      let payload = {
        drawing: `${this.sigCanvas.toDataURL("image/jpeg")}`,
        round_id: props.round.id
      }
      props.submitDrawing(payload)
      this.sigCanvas.clear()
    }
  }

  return (
    <div className="grid-x">
      <h3 className="page-title cell small-12">Draw Away</h3>
      <div>
        Your prompt is: {props.round.currentPrompt}
      </div>
      <div className="sig-pad-container cell small-12">
        <SignatureCanvas
          ref={(ref) => { this.sigCanvas = ref }}
          backgroundColor='#f2f2eb'
        />
      </div>
      <input
        type="submit"
        className="cell small-8 small-offset-2 medium-3 medium-offset-2 align-middle custom-button align-center stacked-button-gap"
        value="Clear"
        onClick={clearCanvas}
      />
      <input
        type="submit"
        className="cell small-8 small-offset-2 medium-3 medium-offset-2 align-middle custom-button align-center"
        value="Submit"
        onClick={submitHandler}
      />
    </div>
  )
}

export default DrawingComponent
