import React, { useState, useEffect } from 'react'

import RoundTile from '../components/RoundTile'

const RoundsIndexContainer = () => {
  const [rounds, setRounds] = useState([])

  useEffect(() => {
    fetch("/api/v1/rounds")
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
      setRounds(body)
    })
    .catch((error) => console.error(`Error in fetch: ${error.message}`))
  }, [])

  let roundsTiles

  if (rounds.length < 1) {
    roundsTiles = "No active games"
  } else {
    roundsTiles = rounds.map(round => {
      return (
        <RoundTile
          key={round.id}
          round={round}
        />
      )
    })
  }

  return (
    <div>
      {roundsTiles}
    </div>
  )
}

export default RoundsIndexContainer
