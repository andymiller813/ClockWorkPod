import com.onformative.yahooweather.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;


YahooWeather weather;
int updateIntervallMillis = 30000; 
TestObserver testObserver;
DeviceRegistry registry;

void setup() {
  size(700, 300);
  fill(0);
  textFont(createFont("Arial", 14));
  // 2442047 = the WOEID of Berlin
  // use this site to find out about your WOEID : http://sigizmund.info/woeidinfo/
  weather = new YahooWeather(this, 638242, "c", updateIntervallMillis);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);

}

void draw() {
  weather.update();
  if (testObserver.hasStrips) { 
  //...  the PixelPusher code is wrapped up in here
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
  text("City: "+weather.getCityName()+"; Region: "+weather.getRegionName()+"; Country: "+weather.getCountryName()+"; Last updated: "+weather.getLastUpdated(), 20, 20);
  text("Lon: "+weather.getLongitude()+" Lat: "+weather.getLatitude(), 20, 40);
  text("WindTemp: "+weather.getWindTemperature()+" WindSpeed: "+weather.getWindSpeed()+" WindDirection: "+weather.getWindDirection(), 20, 60);
  text("Humidity: "+weather.getHumidity()+" visibility: "+weather.getVisibleDistance()+" pressure: "+weather.getPressure()+" rising: "+weather.getRising(), 20, 80);
  text("Sunrise: "+weather.getSunrise()+" sunset: "+weather.getSunset(), 20, 100);
}

public void keyPressed() {
  if (key == 'q') {
    weather.setWOEID(638242);
  }
  if (key == 'r') {
    weather.setWOEID(44418);
  }
}

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
        println("Registry changed!");
        if (updatedDevice != null) {
          println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
};
