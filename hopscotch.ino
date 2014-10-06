
int sensorPin = A0;  
int sensorValue = 0;  // variable to store the value coming from the sensor

void setup() {
  Serial.begin(9600);
}

void loop() {
  // read the value from the sensor:
  sensorValue = analogRead(sensorPin);   
  sensorValue = map(sensorValue,0,1023,0,255);
 Serial.write(sensorValue);
 //Serial.println(sensorValue);
  delay(100);                 
}
