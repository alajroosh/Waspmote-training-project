# Waspmote-training-project

this project work with Waspmote and  Radiation Sensor Board + Geiger tube and 3G module 
<br/>
<br/>
the system process 3G module to complete the handshake and rest of 
the initial setup. Then Waspmote generate a frame with the data from the sensor,than encryption process works (ASE256, ECB Cipher Mode, zero 
paddings), than send the encryped data via 3G module to the cloud server using UDP connection, and then enter sleep 
mode for a set period of time.
<br/>
<br/>

After the encrypted data transferred and stored securely on the server-side, whenever
the user need to retrive and see the actual data, it can be decrypt by entering the secret 
key.
<br/>
<br/>
<b>WaspmoteProject.pde</b>
<br/>
this code work in "Waspmote IDE"
<br/>
fisrt make sure enter this information
<ul>
<li>-apn[] , login[] , password[] for SIM company  </li>
<li>-IP[] the IP of the server and port for the UDP</li>
<li>-setPIN for the SIM card</li>
<li>-you can change the key[] for encryption </li>
</ul>
<br/>


<b>App.js</b>
this file use with react app .
<br/>
I use (create-react-app)
<br/>
make the file in this folder 
<b>my-app/src</b>
<br/>
after that in server 
make the UDP connection listening at same port 
<br/>
and seve the data in file <b>waspmote.js</b>
<br/>
you can use this command (80 is port number)
<br/>
<b>nc -u -l 0.0.0.0 80 > waspmote.js</b>
<br/> 
the  waspmote.js file will be like this
<br/>
<b>const waspmote='D8818E.....';export default waspmote;</b>

*you need this library <b>crypto-js</b> see this link https://www.npmjs.com/package/crypto-js

<b>App.css</b>
make the file in this folder 
<b>my-app/src</b>
this file css (Cascading Style Sheets) for Style the page
