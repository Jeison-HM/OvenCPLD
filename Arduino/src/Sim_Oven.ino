#define ADC_5 13
#define ADC_4 12
#define ADC_3 11
#define ADC_2 10
#define ADC_1 9
#define ADC_0 8
#define D5 7
#define D4 6
#define D3 5
#define D2 4
#define D1 3
#define D0 2
#define S A1
#define R A2
#define SAMPLES 100
#define ADC1 A0
unsigned long temp = 0;
unsigned long acc = 0;
int counter = 0;
float value = 0;
int finalValue = 0;
char rx = 0;
String str = "";
char flag = 0;

void updateDataOutput(int val, char print) {
  int b5, b4, b3, b2, b1, b0;
  b5 = (val >> 5) & 1;
  b4 = (val >> 4) & 1;
  b3 = (val >> 3) & 1;
  b2 = (val >> 2) & 1;
  b1 = (val >> 1) & 1;
  b0 = val & 1;
  digitalWrite(ADC_5, b5);
  digitalWrite(ADC_4, b4);
  digitalWrite(ADC_3, b3);
  digitalWrite(ADC_2, b2);
  digitalWrite(ADC_1, b1);
  digitalWrite(ADC_0, b0);
  if (print == 1) {
    Serial.print("This is ADC Converted Value -> ");
    Serial.print(val);
    Serial.print(" -> ");
    Serial.print(b5);
    Serial.print(b4);
    Serial.print(b3);
    Serial.print(b2);
    Serial.print(b1);
    Serial.println(b0);
  }
  return;
}

void updateOutput(String cmd, char print) {
  String strVal = cmd.substring(1);
  int val = strVal.toInt();
  int b5, b4, b3, b2, b1, b0;
  Serial.println(cmd[0]);
  if (cmd[0] == 'D') {
    b5 = (val >> 5) & 1;
    b4 = (val >> 4) & 1;
    b3 = (val >> 3) & 1;
    b2 = (val >> 2) & 1;
    b1 = (val >> 1) & 1;
    b0 = val & 1;
    digitalWrite(D5, b5);
    digitalWrite(D4, b4);
    digitalWrite(D3, b3);
    digitalWrite(D2, b2);
    digitalWrite(D1, b1);
    digitalWrite(D0, b0);
    if (print == 1) {
      Serial.print("This is Temperature desired Value -> ");
      Serial.print(val);
      Serial.print(" -> ");
      Serial.print(b5);
      Serial.print(b4);
      Serial.print(b3);
      Serial.print(b2);
      Serial.print(b1);
      Serial.println(b0);
    }
  } else if (cmd[0] == 'S') {
    digitalWrite(S, HIGH);
    if (print == 1) {
      Serial.println("Start pulse 5 ms");
    }
    delay(5);
    digitalWrite(S, LOW);

  } else if (cmd[0] == 'R') {
    if (digitalRead(R)) {
      digitalWrite(R, LOW);
      if (print == 1) {
        Serial.println("Turning Off STOP pin");
      }
    } else {
      digitalWrite(R, HIGH);
      if (print == 1) {
        Serial.println("Turning On STOP pin");
      }
    }
  }
  else if (cmd[0] == 'C') {
      updateDataOutput(val, 1);
    }
  return;
}
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(ADC_5, OUTPUT);
  pinMode(ADC_4, OUTPUT);
  pinMode(ADC_3, OUTPUT);
  pinMode(ADC_2, OUTPUT);
  pinMode(ADC_1, OUTPUT);
  pinMode(ADC_0, OUTPUT);
  pinMode(D5, OUTPUT);
  pinMode(D4, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D0, OUTPUT);
  pinMode(S, OUTPUT);
  pinMode(R, OUTPUT);
}

void loop() {
  if (Serial.available()) {
    str = Serial.readString();
    updateOutput(str, 1);
  } /*
  if (flag == 0) {
    temp++;
    if (temp == 400000) {
      temp = 0;
      flag = 1;
    }
  }
  if (flag == 1) {
    acc = acc + analogRead(ADC1);
    counter++;
    if (counter == SAMPLES) {
      counter = 0;
      value = (acc * 5.0 * 1.0) / 1023.0;
      finalValue = int(trunc(value));
      updateDataOutput(finalValue, 1);
      flag = 0;
      acc = 0;
    }
  }*/
}
