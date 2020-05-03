import React from 'react'
import { BrowserRouter, Switch, Route } from 'react-router-dom'

import RoundsIndexContainer from '../containers/RoundsIndexContainer'
import RoundsShowContainer from '../containers/RoundsShowContainer'

export const App = (props) => {
  return (
    <div>
      <BrowserRouter>
        <Switch>
          <Route exact path="/" component={RoundsIndexContainer} />
          <Route exact path="/rounds" component={RoundsIndexContainer} />
          <Route path='/rounds/:id' component={RoundsShowContainer} />
        </Switch>
      </BrowserRouter>
    </div>
  )
}

export default App
