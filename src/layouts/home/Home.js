import React, { Component } from 'react'
import { AccountData, ContractData, ContractForm } from 'drizzle-react-components'
import logo from '../../logo.png'
import GroupController from '../GroupController/GroupController';

class Home extends Component {
  render() {
    return (
      <main className="container">
        <div>
          <h1>Meet-Up</h1>
          <GroupController />
        </div>
      </main>
    )
  }
}

export default Home
