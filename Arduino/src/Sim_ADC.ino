#define PIN_12 13
#define PIN_11 12
#define PIN_10 11
#define PIN_9 10
#define PIN_8 9
#define PIN_7 8
#define PIN_6 7
#define PIN_5 6
#define PIN_4 5
#define PIN_3 4
#define PIN_2 3
#define PIN_1 2
#define PIN_0 A5
#define SEL A4

String str_num = "";
char rx = 0;
int number = 0;
int bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7, bit8, bit9, bit10, bit11, bit12;
int M = 0;
int C = 0;
int D = 0;
int U = 0;
int Ms = 0;
int Cs = 0;
int Ds = 0;
int Us = 0;

void byDigits(int num) {
  M = (num / 1000) % 10;
  C = (num / 100) % 10;
  D = (num / 10) % 10;
  U = num % 10;
  return;
}
void shiftingDigits(int num) {
  Ms = num >> 10;
  Cs = (num - (Ms << 10)) >> 7;
  if(Cs > 9)
  {
    Cs = 0;
  }
  Ds = (num - (Ms << 10) - (Cs << 7)) >> 3;
  if(Ds > 9)
  {
    Ds = 0;
  }
  Us = (num - (Ms << 10) - (Cs << 7) - (Ds << 3));
  if(Us > 9)
  {
    Us = 0;
  }
  return;
}

void updateOutput(int value) {
  bit0 = (value >> 12) & 1;
  bit1 = (value >> 11) & 1;
  bit2 = (value >> 10) & 1;
  bit3 = (value >> 9) & 1;
  bit4 = (value >> 8) & 1;
  bit5 = (value >> 7) & 1;
  bit6 = (value >> 6) & 1;
  bit7 = (value >> 5) & 1;
  bit8 = (value >> 4) & 1;
  bit9 = (value >> 3) & 1;
  bit10 = (value >> 2) & 1;
  bit11 = (value >> 1) & 1;
  bit12 = value & 1;
  digitalWrite(PIN_12, bit0);
  digitalWrite(PIN_11, bit1);
  digitalWrite(PIN_10, bit2);
  digitalWrite(PIN_9, bit3);
  digitalWrite(PIN_8, bit4);
  digitalWrite(PIN_7, bit5);
  digitalWrite(PIN_6, bit6);
  digitalWrite(PIN_5, bit7);
  digitalWrite(PIN_4, bit8);
  digitalWrite(PIN_3, bit9);
  digitalWrite(PIN_2, bit10);
  digitalWrite(PIN_1, bit11);
  digitalWrite(PIN_0, bit12);
}
void setup() {
  // put your setup code here, to run once:
  pinMode(PIN_12, OUTPUT);
  pinMode(PIN_11, OUTPUT);
  pinMode(PIN_10, OUTPUT);
  pinMode(PIN_9, OUTPUT);
  pinMode(PIN_8, OUTPUT);
  pinMode(PIN_7, OUTPUT);
  pinMode(PIN_6, OUTPUT);
  pinMode(PIN_5, OUTPUT);
  pinMode(PIN_4, OUTPUT);
  pinMode(PIN_3, OUTPUT);
  pinMode(PIN_2, OUTPUT);
  pinMode(PIN_1, OUTPUT);
  pinMode(PIN_0, OUTPUT);
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  while (!Serial.available()) {}
  if (Serial.available()) {
    str_num = Serial.readStringUntil('\n');
    number = str_num.toInt();
    if (number > 8191 || number < 0) {
      Serial.println("Please insert a number in the range of 0 - 8191");
    } else {
      byDigits(number);
      shiftingDigits(number);
      Serial.print("This is the representation of the number you inserted: ");
      Serial.print(str_num);
      Serial.print(" -> ");
      Serial.print(M);
      Serial.print(C);
      Serial.print(D);
      Serial.print(U);
      Serial.print(" -> ");
      Serial.print(Ms);
      Serial.print(Cs);
      Serial.print(Ds);
      Serial.println(Us);
    }
  }
}
