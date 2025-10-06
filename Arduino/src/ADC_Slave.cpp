#include <Arduino.h>

#define DATA_3 13
#define DATA_2 12
#define DATA_1 11
#define DATA_0 10
#define ENABLE 9
#define ADC_INT 8
#define SAMPLES 100

unsigned long acc = 0;
float value = 0;
unsigned int finalValue = 0;
int ADC1 = A0; // Voltage
int counter = 0;
int D = 0;
int U = 0;
int set_temp = 45;
int set_time = 13;
char e_flag = 0;

const int stopPin = 7;  // Pin for STOP (toggle)
const int startPin = 6; // Pin for START (pulse)
bool stopState = LOW;   // Keeps track of STOP state

void updateDataOutput(char val, char position, char print)
{
  int b3, b2, b1, b0;
  if (position == 0)
  {
    b3 = (val >> 3) & 1;
    b2 = (val >> 2) & 1;
    b1 = (val >> 1) & 1;
    b0 = val & 1;
    digitalWrite(DATA_3, b3);
    digitalWrite(DATA_2, b2);
    digitalWrite(DATA_1, b1);
    digitalWrite(DATA_0, b0);
  }
  else
  {
    b3 = (val >> 7) & 1;
    b2 = (val >> 6) & 1;
    b1 = (val >> 5) & 1;
    b0 = (val >> 4) & 1;
    digitalWrite(DATA_3, b3);
    digitalWrite(DATA_2, b2);
    digitalWrite(DATA_1, b1);
    digitalWrite(DATA_0, b0);
  }
  if (print == 1)
  {
    Serial.print("This is reg A -> ");
    Serial.print(b3);
    Serial.print(b2);
    Serial.print(b1);
    Serial.println(b0);
  }
  return;
}

void serialCommand()
{
  if (Serial.available())
  {
    String input = Serial.readStringUntil('\n'); // Read the full line until newline

    input.trim(); // Remove any leading/trailing whitespace

    if (input.length() == 0)
      return;

    char command = input.charAt(0);

    if (command == 'S' || command == 's')
    {
      stopState = !stopState; // Toggle stop state
      digitalWrite(stopPin, stopState);
      Serial.print("STOP is now: ");
      Serial.println(stopState ? "ON" : "OFF");
    }
    else if (command == 'P' || command == 'p')
    {
      digitalWrite(startPin, HIGH); // Send pulse
      Serial.println("START pulse sent");
      delay(1000); // 1 second pulse
      digitalWrite(startPin, LOW);
    }
    else if (command == 'C' || command == 'c')
    {
      int equalIndex = input.indexOf('=');
      if (equalIndex != -1)
      {
        String valString = input.substring(equalIndex + 1);
        value = valString.toFloat(); // Convert string to float
        Serial.print("Value updated to: ");
        Serial.println(value);
      }
      else
      {
        Serial.println("Invalid format. Use C=value");
      }
    }
  }
}

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(DATA_3, OUTPUT);
  pinMode(DATA_2, OUTPUT);
  pinMode(DATA_1, OUTPUT);
  pinMode(DATA_0, OUTPUT);
  pinMode(ENABLE, INPUT);
  pinMode(ADC_INT, OUTPUT);
  digitalWrite(ADC_INT, LOW);

  pinMode(stopPin, OUTPUT);
  pinMode(startPin, OUTPUT);
  digitalWrite(stopPin, stopState);
  digitalWrite(startPin, LOW);
  Serial.println("Enter 'S' to toggle STOP, 'P' for START pulse");
}

void loop()
{
  serialCommand();
  if (digitalRead(ENABLE) && e_flag == 0)
  {
    acc = acc + analogRead(ADC1);
    counter++;
    if (counter == SAMPLES)
    {
      counter = 0;
      Serial.println(analogRead(ADC1));
      // value = (((acc * 5.0) / 1023.0) - 273.15);
      // value = (((((acc / SAMPLES * 4.7) / 1023.0) - 0.05) / 0.01) - 273.15); // With correction of 0.05V
      value = ((((acc / SAMPLES) * 5.0) / 1023.0)) * 100;
      finalValue = int(trunc(value));
      Serial.println(finalValue);
      D = (finalValue / 10) % 10;
      U = (finalValue % 10);
      updateDataOutput(D, 0, 1);
      delay(1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      updateDataOutput(U, 0, 1);
      delay(1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      updateDataOutput(finalValue, 0, 1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      updateDataOutput(finalValue, 1, 1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      updateDataOutput(set_temp, 0, 1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      updateDataOutput(set_temp, 1, 1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      updateDataOutput(set_time, 0, 1);
      digitalWrite(ADC_INT, HIGH);
      delay(1);
      digitalWrite(ADC_INT, LOW);
      acc = 0;
      Serial.print("This is the value requested -> ");
      Serial.print(D);
      Serial.println(U);
      Serial.print("This is the temperature reading -> ");
      Serial.println(finalValue);
      Serial.print("This is the set temperature -> ");
      Serial.println(set_temp);
      Serial.print("This is the set time -> ");
      Serial.println(set_time);
      e_flag = 1;
    }
  }
  else if (digitalRead(ENABLE) == 0)
  {
    e_flag = 0;
    acc = 0;
    updateDataOutput(0, 0, 0);
    digitalWrite(ADC_INT, LOW);
    counter = 0;
  }
}
