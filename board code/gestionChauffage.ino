#include <SPI.h>
#include <WiFiNINA.h>
#include "DHT.h"
#include <ArduinoJson.h>
#include "arduino_secrets.h"

#define DHTPIN A1
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;    // your network password (use for WPA, or use as key for WEP)
int keyIndex = 0;                 // your network key Index number (needed only for WEP)

int status = WL_IDLE_STATUS;
WiFiServer server(80);

int fonctionnementGeneral = 1; 
int modeFonctionnement = 1;
bool Operating = false; 
float temperature = 0;
float temperatureVoulu = 19.5 ; 

void setup() {

  Serial.begin(9600); 
  dht.begin();   // départ de la sonde de température
  pinMode(0, OUTPUT); // sortie du chauffage  HIGH = off    LOW on 
 
  WiFi.begin(ssid, pass);
  server.begin();                    // you're connected now, so print out the status
}

void loop() {
  choisirMethod();
  switch (fonctionnementGeneral) {
      case 0:
         digitalWrite(0,HIGH);
        break;
      case 1:
       switch (modeFonctionnement) {
        case 1:
          reguletionTemperature();
          break;
        default:
          Operating = false;
          break;
        }
        if(Operating){
          digitalWrite(0,LOW);
        }else{
          digitalWrite(0,HIGH);
        }
      break;
      case 2:
         digitalWrite(0,LOW);
        break;
      default:
        Operating = false;
        break;
  
  delay(5000);
  }
}
void reguletionTemperature(){
  temperature = dht.readTemperature();
  if( (temperature+0.5) > temperatureVoulu ){
    Operating = false;
  }
  if( (temperatureVoulu-0.5) > temperature){
    Operating = true;
  }
} 
void sendclient(WiFiClient client){
  temperature = dht.readTemperature();
  String message = "Temperature = " + String(temperature)+" °C // Le mode chosir est " + modeFonctionnement  + Operating;
  StaticJsonDocument<200> Appartement;
  Appartement["FonctionnementGeneral"] = fonctionnementGeneral;
  Appartement["Fonctionnement"] = Operating;
  Appartement["Mode"] = modeFonctionnement;
  Appartement["Temperature"] = temperature;
  Appartement["TemperatureVoulu"] = temperatureVoulu;
  Appartement["Heure"] = "Pas encore programmer";
  switch (modeFonctionnement) {
    case 1:
      Appartement["Mode"] = "Temperature";
      break;
    default:
      Appartement["Mode"] = "aucun";
      break;
  }

  String json;
  serializeJson(Appartement, json);
  client.println("HTTP/1.1 200 OK");
  client.println("Content-type:text/html");
  client.println();
  client.println(json);
  client.println();
}

void choisirMethod(){
  WiFiClient client = server.available();   // listen for incoming clients
  if (client) {                             // if you get a client,
    String currentLine = "";      

    while (client.connected()) {            // loop while the client's connected
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();             // read a byte, then
        if (c == '\n') {
          if (currentLine.length() == 0) {
            sendclient(client);
            break;
          } else {    // if you got a newline, then clear currentLine:
            currentLine = "";
          }
        } else if (c != '\r') {  // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
        
        if (currentLine.endsWith("GET /ON")) {  
          fonctionnementGeneral = 1;
        }
        if (currentLine.endsWith("GET /OFF")) {
          fonctionnementGeneral = 0;
        }
        if (currentLine.endsWith("GET /FORCE")) {
          fonctionnementGeneral = 2;
        }
        if (currentLine.endsWith("GET /TEMPERATURE")) {
          modeFonctionnement = 1;
        }

        if (currentLine.endsWith("GET /temperature/12")) {
          Serial.println("commande de test" + currentLine.substring(13));
          temperatureVoulu =  currentLine.substring(13).toFloat();
        }

        if (currentLine.endsWith("GET /12")) {
          temperatureVoulu = 12;
        }
         if (currentLine.endsWith("GET /12.5")) {
          temperatureVoulu = 12.5;
        }
        if (currentLine.endsWith("GET /13")) {
          temperatureVoulu = 13;
        }
        if (currentLine.endsWith("GET /13.5")) {
          temperatureVoulu = 13.5;
        }
        if (currentLine.endsWith("GET /14")) {
          temperatureVoulu = 14;
        }
        if (currentLine.endsWith("GET /14.5")) {
          temperatureVoulu =14.5;
        }
         if (currentLine.endsWith("GET /15")) {
          temperatureVoulu = 15;
        }
        if (currentLine.endsWith("GET /15.5")) {
          temperatureVoulu = 15.5;
        }
        if (currentLine.endsWith("GET /16")) {
          temperatureVoulu = 16;
        }
        if (currentLine.endsWith("GET /16.5")) {
          temperatureVoulu = 16.5;
        }
        if (currentLine.endsWith("GET /17")) {
          temperatureVoulu = 17;
        }
        if (currentLine.endsWith("GET /17.5")) {
          temperatureVoulu = 17.5;
        }
        if (currentLine.endsWith("GET /18")) {
          temperatureVoulu = 18;
        }
         if (currentLine.endsWith("GET /18.5")) {
          temperatureVoulu = 18.5;
        }
        if (currentLine.endsWith("GET /19")) {
          temperatureVoulu = 19;
        }
        if (currentLine.endsWith("GET /19.5")) {
          temperatureVoulu = 19.5;
        }
        if (currentLine.endsWith("GET /20")) {
          temperatureVoulu = 20;
        }
        if (currentLine.endsWith("GET /20.5")) {
          temperatureVoulu = 20.5;
        }
        if (currentLine.endsWith("GET /21")) {
          temperatureVoulu = 21;
        }
        if (currentLine.endsWith("GET /21.5")) {
          temperatureVoulu = 21.5;
        }
        if (currentLine.endsWith("GET /22")) {
          temperatureVoulu = 22;
        }
      }
    }
    client.stop();
  }
}

