# Waspmote-training-project

this project work with Waspmote and  Radiation Sensor Board + Geiger tube and 3G module 
<br/>
the system process 3G module to complete the handshake and rest of 
the initial setup. Then Waspmote generate a frame with the data from the sensor,than encryption process works (ASE256, ECB Cipher Mode, zero 
paddings), than send the encryped data via 3G module to the cloud server using UDP connection, and then enter sleep 
mode for a set period of time.
<br/>
After the encrypted data transferred and stored securely on the server-side, whenever
the user need to retrive and see the actual data, it can be decrypt by entering the secret 
key.
the code work in "Waspmote IDE"
fisrt make sure 

this file use with react app .
