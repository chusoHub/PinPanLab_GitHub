//float to string
#include<stdlib.h>
char buffer[10];
// I2C device class (I2Cdev) demonstration Arduino sketch for MPU6050 class
// 10/7/2011 by Jeff Rowberg <jeff@rowberg.net>
// Updates should (hopefully) always be available at https://github.com/jrowberg/i2cdevlib
//
// Changelog:
//      2013-05-08 - added multiple output formats
//                 - added seamless Fastwire support
//      2011-10-07 - initial release

/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2011 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/

// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"
#include "MPU6050.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 accelgyro;
//MPU6050 accelgyro(0x69); // <-- use for AD0 high

int16_t ax, ay, az;
int16_t gx, gy, gz;



// uncomment "OUTPUT_READABLE_ACCELGYRO" if you want to see a tab-separated
// list of the accel X/Y/Z and then gyro X/Y/Z values in decimal. Easy to read,
// not so easy to parse, and slow(er) over UART.
#define OUTPUT_READABLE_ACCELGYRO

// uncomment "OUTPUT_BINARY_ACCELGYRO" to send all 6 axes of data as 16-bit
// binary, one right after the other. This is very fast (as fast as possible
// without compression or data loss), and easy to parse, but impossible to read
// for a human.
//#define OUTPUT_BINARY_ACCELGYRO


//#define LED_PIN 13
//bool blinkState = false;

float AXenG = 0;
float AYenG = 0;
float AZenG = 0;

String AXenGStr;
String AYenGStr;
String AZenGStr;

float unGenX = 0;
float unGenY = 0;
float unGenZ = 0;

float SegundoOffsetX = 0;
float SegundoOffsetY = 0;
float SegundoOffsetZ = 0;
unsigned long time;


int val = 0;     // variable for reading the pin status
boolean StateAtctive=false;

char rxChar;		

void setup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    // initialize serial communication
    // (38400 chosen because it works as well at 8MHz as it does at 16MHz, but
    // it's really up to you depending on your project)
    Serial.begin(9600);
    // Comunicación serie a 9600 baudios

    // initialize device
    Serial.println("Initializing I2C devices...");
    accelgyro.initialize();
    accelgyro.setFullScaleAccelRange(MPU6050_ACCEL_FS_8);
    //Cambiar en mpu6050.cpp para cambiar rango de escala 
    //void MPU6050::initialize() {
    //  setClockSource(MPU6050_CLOCK_PLL_XGYRO);
    //  setFullScaleGyroRange(MPU6050_GYRO_FS_250);
    //  setFullScaleAccelRange(MPU6050_ACCEL_FS_2);
    //  setFullScaleAccelRange(MPU6050_ACCEL_FS_4);
    //  setSleepEnabled(false); // thanks to Jack Elston for pointing this one out!
    //}

    // verify connection
    Serial.println("Testing device connections...");
    Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

    // use the code below to change accel/gyro offset values
    /*
    Serial.println("Updating internal sensor offsets...");
    // -76	-2359	1688	0	0	0
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1688
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    Serial.print("\n");
    accelgyro.setXGyroOffset(220);
    accelgyro.setYGyroOffset(76);
    accelgyro.setZGyroOffset(-85);
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1688
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    Serial.print("\n");
    */

    // configure Arduino LED for
    //pinMode(LED_PIN, OUTPUT);
    
    //Para +-4 G opción 1:  setFullScaleAccelRange(MPU6050_ACCEL_FS_4); en mcu6050.cpp
    /*unGenX=8391;
    unGenY=8235;
    unGenZ=8327;
    SegundoOffsetX=74;
    SegundoOffsetY=18;
    SegundoOffsetZ=153;
    */
    //Para +-4 G opción 2:  setFullScaleAccelRange(MPU6050_ACCEL_FS_8); en mcu6050.cpp
    unGenX=8391/2;
    unGenY=8235/2;
    unGenZ=8327/2;
    SegundoOffsetX=74/2;
    SegundoOffsetY=18/2;
    SegundoOffsetZ=153/2;
   
}

void loop() {
  

    // read raw accel/gyro measurements from device
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
 
 
    AXenG=(ax+SegundoOffsetX)/unGenX;
    AYenG=(ay+SegundoOffsetY)/unGenY;
    AZenG=(az+SegundoOffsetZ)/unGenZ;
    time=micros();
    //AYenG=sqrt(AYenG);
    
    
    AXenGStr = dtostrf(AXenG, 5, 2, buffer);
    AYenGStr = dtostrf(AYenG, 5, 2, buffer);
    AZenGStr = dtostrf(AZenG, 5, 2, buffer);
    /*
    AXenGStr.replace('.', ',');
    AYenGStr.replace('.', ',');
    AZenGStr.replace('.', ',');
    */
    

 
     Serial.print("acelerometro"); Serial.print(";");
     Serial.print(time); Serial.print(";");
     Serial.print(AXenGStr); Serial.print(";");
     Serial.print(AYenGStr); Serial.print(";");
     Serial.println(AZenGStr);
     
}
