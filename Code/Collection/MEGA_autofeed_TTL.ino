#define outputA 40//38
#define outputB 36//34
#define pelout 22//28//26
#define TTL 32//30
#define rad 2.000 //cm
#define pulses 600.000
#define tardist 30//10 //cm
//resolder pin d6
#include <stdio.h>
 
int aState;
int bState;
int aLS;
int bLS;
float pd;
float dist;
float ecirc;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode (outputA, INPUT);
  pinMode (outputB, INPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(pelout, OUTPUT);
  pinMode(TTL, OUTPUT);
  digitalWrite(TTL, LOW);
  digitalWrite(pelout, HIGH);
  Serial.begin(9600);
  Serial.print("Start");
  aLS = digitalRead(outputA);
  ecirc = 2 * 3.14159 * rad;
  pd = ecirc / pulses;   //pulse distance variable
  Serial.print(pd);
}
void feed(){
  digitalWrite(pelout, LOW);
  Serial.print("fed");
  delay(100);
  digitalWrite(pelout, HIGH); 
   
}


// theloop function runs over and over again forever
void loop() {
  digitalWrite(pelout, LOW);
  aState = digitalRead(outputA);

 if (aState != aLS){
      if ( digitalRead(outputB) != aState ){   //detects clockwise rotation
        //digitalWrite(LED_BUILTIN, HIGH);
        digitalWrite(TTL, HIGH);
        //delay(.25);
        digitalWrite(TTL, LOW);
        //digitalWrite(LED_BUILTIN, LOW);
        
        //digitalWrite(TTL, LOW);
        dist = dist + pd;
        Serial.println(dist);
      }
      aLS = aState;
    }
 
  if (dist >= tardist){
    feed();
    dist = 0;
    }
 
}



  
