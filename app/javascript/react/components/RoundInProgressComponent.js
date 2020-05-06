import React, { useState, useEffect } from 'react'

const RoundInProgressComponent = (props) => {
  return (
    <div className="cell small-8 small-offset-2 align-middle align-center waiting">
      Waiting for everyone else to take their turns...
    </div>
  )
}

export default RoundInProgressComponent
