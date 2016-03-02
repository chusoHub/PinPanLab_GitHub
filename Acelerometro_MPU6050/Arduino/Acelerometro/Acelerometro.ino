//Programa para Puertas Fotoeléctricas PinPanLab   
#include<stdlib.h>
char buffer[10];

#include "I2Cdev.h"
#include "MPU6050.h"

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif


MPU6050 accelgyro;

int16_t ax, ay, az;
int16_t gx, gy, gz;

#define OUTPUT_READABLE_ACCELGYRO


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


int val = 0;     
boolean StateAtctive=false;

char rxChar;		

void setup() {
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    Serial.begin(9600);
 
    Serial.println("Initializing I2C devices...");
    accelgyro.initialize();
    accelgyro.setFullScaleAccelRange(MPU6050_ACCEL_FS_8);
    Serial.println("Testing device connections...");
    Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");
 
    unGenX=8391/2;
    unGenY=8235/2;
    unGenZ=8327/2;
    SegundoOffsetX=74/2;
    SegundoOffsetY=18/2;
    SegundoOffsetZ=153/2;
   
}

void loop() {
  
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); 
 
    AXenG=(ax+SegundoOffsetX)/unGenX;
    AYenG=(ay+SegundoOffsetY)/unGenY;
    AZenG=(az+SegundoOffsetZ)/unGenZ;
    time=micros();
  
    AXenGStr = dtostrf(AXenG, 5, 2, buffer);
    AYenGStr = dtostrf(AYenG, 5, 2, buffer);
    AZenGStr = dtostrf(AZenG, 5, 2, buffer);

     Serial.print("acelerometro"); Serial.print(";");
     Serial.print(time); Serial.print(";");
     Serial.print(AXenGStr); Serial.print(";");
     Serial.print(AYenGStr); Serial.print(";");
     Serial.println(AZenGStr);
     
}
//Programa para Puertas Fotoeléctricas PinPanLab  
