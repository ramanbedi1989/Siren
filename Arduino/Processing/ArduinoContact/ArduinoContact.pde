import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
public static final int GREEN_SIGNAL = 13;
public static final int RED_SIGNAL = 8;
public static final String TRAFFIC_LIGHT_ENDPOINT = "https://siren-app.herokuapp.com/api/v1/emergencies/:id/traffic_light_details";
public static final String EMERGENCY_ROUTE_ID = "9";
void setup() {
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(GREEN_SIGNAL, Arduino.OUTPUT);
  arduino.pinMode(RED_SIGNAL, Arduino.OUTPUT);
}

void draw() {
  String [] json = loadStrings (TRAFFIC_LIGHT_ENDPOINT.replaceAll(":id", EMERGENCY_ROUTE_ID));
  println("JSON is " + json[0]);
  JSONObject jsonObj = parseJSONObject(json[0]);
  if (jsonObj == null) {
    println("JSONObject could not be parsed");
  } else {
    int lightStatus = jsonObj.getInt("light_status");
    println("light status is " + lightStatus);
    if(lightStatus == 1) {
      arduino.digitalWrite(GREEN_SIGNAL, Arduino.HIGH);
      arduino.digitalWrite(RED_SIGNAL, Arduino.LOW);
    } else {
      arduino.digitalWrite(GREEN_SIGNAL, Arduino.LOW);
      arduino.digitalWrite(RED_SIGNAL, Arduino.HIGH);
    }
  }
  delay(100);
}