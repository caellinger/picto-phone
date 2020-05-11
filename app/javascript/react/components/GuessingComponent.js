import React, { useState } from 'react'

const GuessingComponent = (props) => {
  const [guess, setGuess] = useState(null)

  const handleInputChange = (event) => {
    setGuess(event.currentTarget.value)
  }

  let submitHandler = (event) => {
    event.preventDefault()

    if (guess = "") {
      alert("You have to take a guess!");
    } else {
      let payload = {
      }
      let endpoint = "/api/v1/participants"
      props.submitDrawing(payload, endpoint)
    }
  }

  return (
    <div className="grid-x">
      <h3 className="page-title cell small-12">Take a Wild Guess</h3>
      <div className="guess-form cell small-12 grid-container">
        <div className="grid-x">
          <form
            onSubmit={submitHandler}
            className="cell small-12 grid-container"
          >
            <div className="grid-x">
              <div className="cell small-8 small-offset-2">
                <input
                  type="text"
                  onChange={handleInputChange}
                  value={guess}
                />
              </div>

              <div className="cell small-12 grid-container">
                <div className="grid-x">
                  <input
                    type="submit"
                    value="Submit"
                    className="cell small-8 small-offset-2 medium-4 medium-offset-4 align-middle custom-button align-center"
                  />
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  )
}

export default GuessingComponent
