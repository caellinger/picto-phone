import React, { useState, useEffect } from 'react'

import ResponseComponent from './ResponseComponent'

const FullSequenceComponent = (props) => {
  const [sequence, setSequence] = useState([])

  useEffect(() => {
    const id = props.roundID
    fetch(`/api/v1/rounds/${id}`)
    .then((response) => {
      if (response.ok) {
        return response
      } else {
        let errorMessage = `${response.status} (${response.statusText})`
        let error = new Error(errorMessage)
        throw error
      }
    })
    .then((response) => {
      return response.json()
    })
    .then((body) => {
      setSequence(body.round.participants.participants)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  })

  let responses = sequence.map(element => {
    return <ResponseComponent
      key={element.id}
      participant={element}
    />
  })

  return (
    <div>{responses}</div>
  )
}

export default FullSequenceComponent
