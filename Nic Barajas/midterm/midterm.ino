int temperaturePin = A2;
int heatPin = 6;
int heatVal;
int lightPin = A0;
int ledPin = 8;

void setup() {
  pinMode(temperaturePin, INPUT);
  pinMode(lightPin, INPUT);
  pinMode(heatPin, OUTPUT);
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
    // show temperature...?
    float temperature = analogRead(temperaturePin) * .004882814;
    temperature = (temperature - .5) *100;
//    Serial.println(temperature);

    int lightVal = analogRead(lightPin);
    heatVal = map(lightVal, 200, 500, 255, 0);
    
    if (heatVal < 0) {
      heatVal = 0;
    } else if (heatVal > 255) {
      heatVal = 255;
    }
    
    analogWrite(heatPin, heatVal);
//    int sHV = Serial.parseInt();
//    analogWrite(heatPin, sHV);
    
    if(Serial.available()) {
      String pL = "Light: ";
      String pH = ", Heat: ";
      Serial.println(pL + lightVal + pH + heatVal);//sHV);
    }
    
    if (lightVal < 400) {
      digitalWrite(ledPin, HIGH);
    } else {
      digitalWrite(ledPin, LOW);
    }
    
}
