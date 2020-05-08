import React, { useState } from 'react'
import SignatureCanvas from 'react-signature-canvas'

const DrawingComponent = (props) => {

  return (
    <div className="sigPadContainer">
      <SignatureCanvas
        ref={(ref) => { this.sigCanvas = ref }}
        penColor='green'
        backgroundColor='rgb(236,236,236)'
      />
    </div>
  )
}

export default DrawingComponent
