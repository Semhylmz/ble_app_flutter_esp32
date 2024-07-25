#include <ArduinoJson.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <DHT.h>

#define LEDPIN 17
#define DHTPIN 16
#define DHTTYPE DHT11

#define SERVICE_UUID "87e3a34b-5a54-40bb-9d6a-355b9237d42b"
#define CHARACTERISTIC_UUID "cdc7651d-88bd-4c0d-8c90-4572db5aa14b"
#define SERVERNAME "DHT Sensor"

DHT dht(DHTPIN, DHTTYPE);

BLEServer* pServer = NULL;
BLEService* pService = NULL;
BLECharacteristic* dhtCharacteristic = NULL;
BLEAdvertising* pAdvertising = NULL;

uint8_t ledStatus = 0;
float temperature = 0.0;
float humidity = 0.0;
bool deviceConnected = false;

DynamicJsonDocument sendDoc(1024);
DynamicJsonDocument receivedDoc(1024);

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("Device: Connected!");
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("Device: Disconnected!");
    BLEDevice::startAdvertising();
  }
};

class CharacteristicCallback : public BLECharacteristicCallbacks {

  void onWrite(BLECharacteristic* dhtCharacteristic) {
    String value = dhtCharacteristic->getValue().c_str();

    deserializeJson(receivedDoc, value.c_str());

    const char* ledStatusData = receivedDoc["ledStatus"];
    if (ledStatusData) {
      if (strcmp(ledStatusData, "1") == 0) {
        ledStatus = 1;
        digitalWrite(LEDPIN, HIGH);
      } else {
        ledStatus = 0;
        digitalWrite(LEDPIN, LOW);
      }
    }
  }
};

void setupBle() {
  Serial.println("BLE initializing...");
  BLEDevice::init(SERVERNAME);

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  pService = pServer->createService(SERVICE_UUID);
  dhtCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);

  dhtCharacteristic->addDescriptor(new BLE2902());
  dhtCharacteristic->setCallbacks(new CharacteristicCallback());

  pService->start();

  pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x12);

  BLEDevice::startAdvertising();

  Serial.println("BLE initialized. Waiting for client to connect...");
}

void getDhtData() {
  humidity = dht.readHumidity();
  temperature = dht.readTemperature();

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("DHT sensor error!");
    return;
  }

  delay(500);
}

void sendData() {
  sendDoc["ledStatus"] = ledStatus;
  sendDoc["temperature"] = temperature;
  sendDoc["humidity"] = humidity;

  String data;
  serializeJson(sendDoc, data);
  Serial.println(data);

  dhtCharacteristic->setValue(data.c_str());
  dhtCharacteristic->notify();
}

void setup() {
  Serial.begin(115200);
  pinMode(LEDPIN, OUTPUT);
  digitalWrite(LEDPIN, ledStatus);
  setupBle();
  dht.begin();
}

void loop() {
  getDhtData();

  if (deviceConnected) {
    sendData();
    delay(10);
  }
}