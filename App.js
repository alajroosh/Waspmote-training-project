
import React from 'react'
import ReactDOM from 'react-dom';
import './App.css';
import waspmote from './waspmote.js'; 
var CryptoJS = require("crypto-js");

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {messageEncrypt:'this message is encrypt enter the key!',value: '',originalText:'',wrongKey:''};

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit (event) {
    try {
   var bytes  = CryptoJS.AES.decrypt({ciphertext:CryptoJS.enc.Hex.parse(waspmote)},CryptoJS.enc.Utf8.parse(this.state.value) ,{mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.ZeroPadding });
   console.log(bytes);
   console.log(bytes.toString(CryptoJS.enc.Utf8));
      this.setState({originalText: bytes.toString(CryptoJS.enc.Utf8),wrongKey:'',messageEncrypt:''});
    console.log(this.state.originalText);
    }
    catch(error) {
      this.setState({wrongKey:'the key is wrong try again ',messageEncrypt:'this message is encrypt enter the key!',originalText:''});
      console.log("try again")
      console.log(error)}
      event.preventDefault();
  }
  render() {

    return (
<div className="content">
<img src="centerLogo.png" alt="Center of Excellence for information security" />

     <h2>{this.state.messageEncrypt}</h2>
      <form onSubmit={this.handleSubmit}>
        <label>
          key:
          <input type="text" value={this.state.value} onChange={this.handleChange} />
        </label>
        <input type="submit" value="Submit" /><h5>{this.state.wrongKey}</h5>
      </form>
      <h3>{this.state.originalText}</h3>
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
export default App;