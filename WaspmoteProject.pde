

#include "Wasp3G.h"
#include <WaspFrame.h>
#include "WaspSensorRadiation.h"
#include "WaspAES.h"

char apn[] = "jawalnet.com.sa";
char login[] = "";
char password[] = "";

char IP[] = "188.166.148.220";
uint16_t port = 6000;
// Variable to store measured radiation
float radiationcpm;
float radiationusv;

char node_ID[] = "Node_01";


int8_t answer;


// Encryption

// Define a 24-Byte (AES-256) private key to encrypt message  
char key[] = "B?E(H+MbPeShVmYq3t6w9z$C&F)J@NcR"; 

// original message on which the algorithm will be applied 
char message[] = "This_is_a_message"; 

// Variable for encrypted message's length
uint16_t encrypted_length;

// Declaration of variable encrypted message 
uint8_t encrypted_message[300]; 


char encrypted_message_string[300];
char encrypted_message_js[300];

void setup()
{
    USB.ON();
  // Set the Waspmote ID
  frame.setID(node_ID); 
  
  // Starting Radiation Board
  RadiationBoard.ON();
  delay(100);

    USB.println(F("**************************"));
    // 1. sets operator parameters
    _3G.set_APN(apn, login, password);
    // And shows them
    _3G.show_APN();
    USB.println(F("**************************"));
}

void loop()
{
       ///////////////////////////////////////////
  // 1. Turn on the board
  /////////////////////////////////////////// 
  RadiationBoard.ON();
  delay(100);


  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////  
  // Read radiation for 5 secs
  radiationcpm = RadiationBoard.getCPM(5000);
  radiationusv = RadiationBoard.getRadiation();
  

  ///////////////////////////////////////////
  // 3. Turn off the sensors
  /////////////////////////////////////////// 
  // Power off the board
  RadiationBoard.OFF();


  ///////////////////////////////////////////
  // 4. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // Add temperature
  frame.addSensor(SENSOR_RAD, radiationcpm);
  frame.addSensor(SENSOR_STR, " [cpm]");
  frame.addSensor(SENSOR_RAD, radiationusv);
  frame.addSensor(SENSOR_STR, " [uSv/h]");
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  frame.addSensor(SENSOR_STR,RTC.getTime());

// Show the frame
  frame.showFrame();

//  //wait 2 seconds
//  delay(2000);



////////////////////////////////////////////////////////////////
// 1. Encrypt message
////////////////////////////////////////////////////////////////
  USB.println(F("1. Encrypt message"));
  
  // 1.1. Calculate length in Bytes of the encrypted message 
  encrypted_length = AES.sizeOfBlocks(frame.length);

  // 1.2. Calculate encrypted message with ECB cipher mode and PKCS5 padding. 
  AES.encrypt(  AES_256
              , key
              , frame.buffer
              , frame.length
              , encrypted_message
              , ECB
              , ZEROS); 


  // 1.3. Printing encrypted message    
  USB.print(F("AES Encrypted message:")); 
  AES.printMessage( encrypted_message, encrypted_length); 

  // 1.4. Printing encrypted message's length 
  USB.print(F("AES Encrypted length:")); 
  USB.println( (int)encrypted_length);
  USB.println();

 Utils.hex2str(encrypted_message, encrypted_message_string, encrypted_length);

strcat(encrypted_message_js,"const waspmote='");
strcat(encrypted_message_js,encrypted_message_string);
strcat(encrypted_message_js,"';export default waspmote");

//USB.print(encrypted_message_js);
//USB.println();
//
//  
  delay(5000);
  USB.println(F("*********"));

    // 2. activates the 3G module:
    answer = _3G.ON();    
    if ((answer == 1) || (answer == -3))
    {
 
        USB.println(F("3G module ready..."));

        // 3. sets pin code:
        USB.println(F("Setting PIN code..."));
        // **** must be substituted by the SIM code
        if (_3G.setPIN("9330") == 1) 
        {
            USB.println(F("PIN code accepted"));
        }
        else
        {
            USB.println(F("PIN code incorrect"));
        }

        // 4. waits for connection to the network
        answer = _3G.check(180);    
        if (answer == 1)
        {    
            USB.println(F("3G module connected to the network..."));

            // 5. configures UDP connection
            USB.print(F("Setting connection..."));
            answer = _3G.configureTCP_UDP();
            if (answer == 1)
            {
                USB.println(F("Done"));

                USB.print(F("Opening UDP socket..."));
                // 6. opens a UDP socket
                answer = _3G.createSocket(UDP_CLIENT);
                if (answer == 1)
                {
                    USB.println(F("Connected"));
                    if(_3G.getIP() == 1)
                    {
                        // if configuration is success shows the IP address
                        USB.print(F("IP address: ")); 
                        USB.println(_3G.buffer_3G);
                    }


                    // 8. sends a frame
                                      answer = _3G.sendData(encrypted_message_js, IP, port);

                    if (answer == 1) 
                    {
                        USB.println(F("Done"));
                    }
                    else if (answer == 0)
                    {
                        USB.println(F("Fail"));
                    }
                    else 
                    {
                        USB.print(F("Fail. Error code: "));
                        USB.println(answer, DEC);
                        USB.print(F("CME or IP error code: "));
                        USB.println(_3G.CME_CMS_code, DEC);
                    }


                    USB.print(F("Closing UDP socket..."));  
                    // 9. closes socket
                    if (_3G.closeSocket() == 1)
                    {
                        USB.println(F("Done"));
                    }
                    else
                    {
                        USB.println(F("Fail"));
                    }
                }
                else if (answer <= -4)
                {
                    USB.print(F("Connection failed. Error code: "));
                    USB.println(answer, DEC);
                    USB.print(F("CME error code: "));
                    USB.println(_3G.CME_CMS_code, DEC);
                }
                else 
                {
                    USB.print(F("Connection failed. Error code: "));
                    USB.println(answer, DEC);
                }           
            }
            else if (answer <= -10)
            {
                USB.print(F("Configuration failed. Error code: "));
                USB.println(answer, DEC);
                USB.print(F("CME error code: "));
                USB.println(_3G.CME_CMS_code, DEC);
            }
            else 
            {
                USB.print(F("Configuration failed. Error code: "));
                USB.println(answer, DEC);
            }
        }
        else
        {
            USB.println(F("3G module cannot connect to the network..."));
        }
    }
    else
    {
        // Problem with the communication with the 3G module
        USB.println(F("3G module not started"));
    }

    // 10. Powers off the 3G module
    _3G.OFF();
encrypted_message_js[0]=0;

   USB.println(F("Sleeping..."));

 // 11. sleeps one hour
PWR.deepSleep("00:01:00:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

}




