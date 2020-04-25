import React from 'react'
import { BrowserRouter, Switch, Route } from 'react-router-dom'

import RoundsIndexContainer from '../containers/RoundsIndexContainer'

export const App = (props) => {
  return (
    <div>
      <BrowserRouter>
        <Switch>
          <Route exact path="/" component={RoundsIndexContainer} />
        </Switch>
      </BrowserRouter>
    </div>
  )
}

export default App
