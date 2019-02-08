#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

/* Set these to your desired credentials. */
const char *ssid = "Web Dev Fusion";
const char *password = "9462321101";
boolean ledState = false;

ESP8266WebServer server(80);

void handleRoot() {
  // Sending sample message if you try to open configured IP Address
  server.send(200, "text/html", "<h1>You are connected</h1>");
}

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);
  delay(1000);
  Serial.begin(9600);
  
  //Trying to connect to the WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("*");
  }

  // Setting IP Address to 192.168.1.200, you can change it as per your need, you also need to change IP in Flutter app too.
  
  IPAddress ip(192, 168, 1, 200);
  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.on("/led", toggleLed);
  server.on("/led/on", turnOnLed);
  server.on("/led/off", turnOffLed);
  server.begin();
  Serial.println("HTTP server started");
}

void toggleLed() {
  ledState = ! ledState;
  if (ledState == true) {
    digitalWrite(BUILTIN_LED, ledState);
    server.send(200, "text/plain", "Off");
    Serial.println("LED Off");
  } else {
    digitalWrite(BUILTIN_LED, ledState);
    server.send(200, "text/plain", "On");
    Serial.println("LED On");
  }
}

void turnOnLed() {
  ledState = false;
  digitalWrite(BUILTIN_LED, ledState);
  server.send(200, "text/plain", "On");
  Serial.println("LED On");
}

void turnOffLed() {
  ledState = true;
  digitalWrite(BUILTIN_LED, ledState);
  server.send(200, "text/plain", "Off");
  Serial.println("LED Off");
}
//
void loop() {
  server.handleClient();
}
