#include <ArduinoJson.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <DHT.h>

class MyServerCallbacks : public BLEServerCallbacks {
};

class CharacteristicCallback : public BLECharacteristicCallbacks {
};

void setupBle() {
  Serial.println("BLE initializing...");

  Serial.println("BLE initialized. Waiting for client to connect...");
}

void getDhtData() {
}

void sendData() {
}

void setup() {
}

void loop() {
}