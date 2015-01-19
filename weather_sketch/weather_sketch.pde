import com.onformative.yahooweather.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;


YahooWeather weather;

// Updates weather every 30s
int updateIntervallMillis = 30000; 
PixelPusherDeviceObserver deviceObserver;
DeviceRegistry registry;

void setup() {
  size(700, 300);
  fill(0);
  textFont(createFont("Arial", 14));
  // 2442047 = the WOEID of Berlin
  // use this site to find out about your WOEID : http://sigizmund.info/woeidinfo/
  // Portland WOEID = 2475687
  weather = new YahooWeather(this, 2475687, "c", updateIntervallMillis);
  registry = new DeviceRegistry();
  deviceObserver = new PixelPusherDeviceObserver();
  registry.addObserver(deviceObserver);

}

void draw() {
  weather.update();
  if (deviceObserver.hasStrips) { 
    int stripy = 0;
    int height = 0;
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    int yscale = height / (strips.size());
    for(Strip strip : strips) {
      int xscale = width / strip.getLength();
      for (int stripx = 0; stripx < strip.getLength(); stripx++) {
         color c = get(stripx*xscale, stripy*yscale);
         strip.setPixel(c, stripx);
      }
      stripy++;
    }  
  }
  background(255);
  //use https://github.com/onformative/YahooWeather/blob/master/src/com/onformative/yahooweather/processing20/YahooWeather.java
  // for a list of Yahoo Weather accessors
  text("City: "+weather.getCityName()+"; Region: "+weather.getRegionName()+"; Country: "+weather.getCountryName()+"; Last updated: "+weather.getLastUpdated(), 20, 20);
  text("Lon: "+weather.getLongitude()+" Lat: "+weather.getLatitude(), 20, 40);
  text("WindTemp: "+weather.getWindTemperature()+" WindSpeed: "+weather.getWindSpeed()+" WindDirection: "+weather.getWindDirection(), 20, 60);
  text("Humidity: "+weather.getHumidity()+" visibility: "+weather.getVisibleDistance()+" pressure: "+weather.getPressure()+" rising: "+weather.getRising(), 20, 80);
  text("Sunrise: "+weather.getSunrise()+" sunset: "+weather.getSunset(), 20, 100);
  int tempCelsius = weather.getTemperature();
  int tempFahrenheit = celsiusToFahrenheit(tempCelsius);
  text("Current Temperature: " + tempCelsius + "°C, " + tempFahrenheit + "°F", 20, 120);
}

public void keyPressed() {
  if (key == 'q') {
    weather.setWOEID(638242);
  }
  if (key == 'r') {
    weather.setWOEID(44418);
  }
}

class PixelPusherDeviceObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
        println("Registry changed!");
        if (updatedDevice != null) {
          println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
};

public int celsiusToFahrenheit(int tempCelsius) {
    return (((tempCelsius * 9)/5)+32);
}
