import React, { useState } from 'react'
import SignaturePad from 'react-signature-pad-wrapper'
import SignatureCanvas from 'react-signature-canvas'

const DrawingComponent = (props) => {
  const [imageSubmitted, setImageSubmitted] = useState(false)
  const signaturePad = {}
  let submitHandler = (event) => {
    event.preventDefault()

    if (this.signaturePad.isEmpty()) {
      alert("You can't submit an empty drawing!");
    } else {
      this.signaturePad.backgroundColor='rgb(242,242,235)'
      let dataURL = {
        drawing: `${this.signaturePad.toDataURL("image/jpeg")}`,
        user: props.user,
        round: props.round
      } // // TODO: this needs to include user info

      fetch("/api/v1/drawings", {
        credentials: "same-origin",
        method: "POST",
        body: JSON.stringify(dataURL),
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json"
        }
      })
      .then(response => {
        if (response.ok) {
          setImageSubmitted(true)
        } else {
          let errorMessage = `${response.status} (${response.statusText})`,
            error = new Error(errorMessage)
          throw error
        }
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`))

      this.signaturePad.clear()
    }
  }
  // height={500}
  let ref = {
    backgroundColor: 'rgb(242,242,235)',
    penColor: 'rgb(250,0,0)'
  }
  signaturePad.backgroundColor='rgb(242,242,235)'
  signaturePad.penColor='rgb(250,0,0)'

  return (
    <div className="grid-x">
      <div>
        Your prompt is: Elephant
      </div>
      <div className="sig-pad-container cell small-12">
        <SignaturePad
          ref={(ref) => { this.signaturePad = ref }}
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
