//Programa para PinPanLab Jesús Vicente
int sensorValue = 1;
int sensorValue1Ant = 1; 
int sensorValue2Ant = 1;
int sensorValue3Ant = 1;
long time;
//quitar boton  y cambiar 10 a 9 y 9 a 3
void setup() {
  Serial.begin(9600); 
  pinMode(11, INPUT);
  pinMode(9, INPUT);
  pinMode(3, INPUT);
 
  digitalWrite(11,HIGH);
  digitalWrite(9,HIGH);
  digitalWrite(3,HIGH);
 
  sensorValue = digitalRead(11);
  Serial.print("Puerta1");Serial.print(";");
  //time=micros();
  Serial.print(0);Serial.print(";");
  Serial.println(sensorValue);
  sensorValue1Ant=sensorValue;
  
  sensorValue = digitalRead(9);
  Serial.print("Puerta2");Serial.print(";");
  //time=micros();
  Serial.print(0);Serial.print(";");
  Serial.println(sensorValue); 
  sensorValue2Ant=sensorValue;
 
  sensorValue = digitalRead(3);
  Serial.print("Puerta3");Serial.print(";");
  //time=micros();
  Serial.print(0);Serial.print(";");
  Serial.println(sensorValue); 
 sensorValue3Ant=sensorValue; 
  
}

void loop() {
 sensorValue = digitalRead(11);
  if (sensorValue1Ant!=sensorValue){
  Serial.print("Puerta1");Serial.print(";");
  Serial.print(micros());Serial.print(";");
  Serial.println(sensorValue);
  sensorValue1Ant=sensorValue;
  };
 sensorValue = digitalRead(9);
  if (sensorValue2Ant!=sensorValue){
  Serial.print("Puerta2");Serial.print(";");
  time=micros();
  Serial.print(time);Serial.print(";");
  Serial.println(sensorValue);
  sensorValue2Ant=sensorValue;
  };
  sensorValue = digitalRead(3); 
  if (sensorValue3Ant!=sensorValue){
  Serial.print("Puerta3");Serial.print(";");
  time=micros();
  Serial.print(time);Serial.print(";");
  Serial.println(sensorValue);
  sensorValue3Ant=sensorValue;
  };

  // sensorValue = digitalRead(10);
  //sensorValue = digitalRead(11);
 //sensorValue = digitalRead(12); 
 
  
};
//Programa para PinPanLab Jesús Vicente
