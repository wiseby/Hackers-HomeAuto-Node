#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <DHT.h>

#define DHTPIN 2
#define DHTTYPE DHT11

#ifndef STASSID
#define STASSID "#Telia-B179E0"
#define STAPSK "timeisrelative"
#endif

DHT dht(DHTPIN, DHTTYPE);

const char* ssid = STASSID;
const char* password = STAPSK;

float temperature;
float humidity;

unsigned long previousMillis = 0;        // will store last temp was read
const long interval = 2000;              // interval at which to read sensor

String response = "";

ESP8266WebServer server(80);

void handle_root() {
  Serial.println("Root requested");
  server.send(200, "text/plain", "Hello from the weather esp8266, read from /getdata");
  delay(100);
}

void setup() {

  Serial.begin(115200);
  
  // Init DHT11 sensor
  dht.begin();
  
  WiFi.begin(ssid, password);

  Serial.println("Setting things up...");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("DHT Weather Reading Server");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", handle_root);

  server.on("/getdata", [](){

    // Reading sensors
    GetData();
    Serial.println("Building json string");
     
    // Build response string
    response += "{\r\n";
    response += "\"Server\":\"livingroom\",\r\n";
    response += "\"Temperature\":\"" + String((int)temperature) + "\",\r\n";
    response += "\"Humidity\":\"" + String((int)humidity) + "\"\r\n";
    response += "}\r\n";
        
    // Send back as response
    server.send(200, "application/json", response);
    delay(1);
    Serial.println("Client disconnected");  
  });

  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  response = "";
  server.handleClient();
}

void GetData() {
  // Wait at least 2 seconds seconds between measurements.
  // if the difference between the current time and last time you read
  // the sensor is bigger than the interval you set, read the sensor
  // Works better than delay for things happening elsewhere also
  unsigned long currentMillis = millis();
 
  if(currentMillis - previousMillis >= interval) {
    // save the last time you read the sensor 
    previousMillis = currentMillis;   
 
    // Reading temperature for humidity takes about 250 milliseconds!
    // Sensor readings may also be up to 2 seconds 'old' (it's a very slow sensor)
    humidity = dht.readHumidity();          // Read humidity (percent)
    temperature = dht.readTemperature();     // Read temperature
    // Check if any reads failed and exit early (to try again).
    if (isnan(humidity) || isnan(temperature)) {
      Serial.println("Failed to read from DHT sensor!");
      return;
    }
  }
}
