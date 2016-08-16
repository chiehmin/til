### Test Program

```java
package com.fatminmin.locationprovidertest;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.GpsSatellite;
import android.location.GpsStatus;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    static final String TAG = "location test";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        List<String> providers = lm.getAllProviders();
        Log.i(TAG, providers.toString());
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION},
                    1);
        } else {
            for(String provider : providers) {
                Location l = lm.getLastKnownLocation(provider);
                if( l != null)
                    Log.i(TAG, provider + " location: " + l.getLongitude() + " " + l.getLatitude() + " " + l.getAltitude());
            }
            lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 1000, new LocationListener() {
                @Override
                public void onLocationChanged(Location l) {
                    Log.i(TAG,"location update: " + l.getLongitude() + " " + l.getLatitude() + " " + l.getAltitude());
                }

                @Override
                public void onStatusChanged(String s, int i, Bundle bundle) {

                }

                @Override
                public void onProviderEnabled(String s) {
                    Log.i(TAG, s + "enabled");
                }

                @Override
                public void onProviderDisabled(String s) {

                }
            });
            lm.addGpsStatusListener(new GpsStatus.Listener() {
                @Override
                public void onGpsStatusChanged(int i) {
                    if(i == GpsStatus.GPS_EVENT_SATELLITE_STATUS) {
                        GpsStatus gs = lm.getGpsStatus(null);
                        for (GpsSatellite sl : gs.getSatellites()) {
                            Log.i(TAG, sl.getElevation() + "");
                        }
                        try {
                            Thread.sleep(10000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
        }

    }
}

```

### Output for using mock location
No GpsSatellite output

```
08-16 15:44:06.235 26753-26753/com.fatminmin.locationprovidertest I/location test: [passive, gps, network]
08-16 15:44:06.237 26753-26753/com.fatminmin.locationprovidertest I/location test: passive location: 120.92341727037781 24.83985212941556 129.92744114357677
08-16 15:44:06.237 26753-26753/com.fatminmin.locationprovidertest I/location test: gps location: 120.92341727037781 24.83985212941556 129.92744114357677
08-16 15:44:06.238 26753-26753/com.fatminmin.locationprovidertest I/location test: network location: 120.923 24.84 0.0
08-16 15:44:06.674 26753-26753/com.fatminmin.locationprovidertest I/location test: location update: 120.92341662095644 24.83985200524136 129.92744114357677
```
### Output for using real gps
```
08-16 15:43:25.439 25860-25860/com.fatminmin.locationprovidertest I/location test: [passive, gps, network]
08-16 15:43:25.453 25860-25860/com.fatminmin.locationprovidertest I/location test: passive location: 120.997545 24.7870368 0.0
08-16 15:43:25.456 25860-25860/com.fatminmin.locationprovidertest I/location test: network location: 120.997545 24.7870368 0.0
08-16 15:43:27.149 25860-25860/com.fatminmin.locationprovidertest I/location test: 32.0
08-16 15:43:27.149 25860-25860/com.fatminmin.locationprovidertest I/location test: 23.0
08-16 15:43:27.150 25860-25860/com.fatminmin.locationprovidertest I/location test: 49.0
08-16 15:43:27.150 25860-25860/com.fatminmin.locationprovidertest I/location test: 34.0
08-16 15:43:27.150 25860-25860/com.fatminmin.locationprovidertest I/location test: 19.0
08-16 15:43:27.150 25860-25860/com.fatminmin.locationprovidertest I/location test: 59.0
08-16 15:43:27.151 25860-25860/com.fatminmin.locationprovidertest I/location test: 73.0
08-16 15:43:27.151 25860-25860/com.fatminmin.locationprovidertest I/location test: 18.0
08-16 15:43:27.151 25860-25860/com.fatminmin.locationprovidertest I/location test: 13.0
08-16 15:43:27.151 25860-25860/com.fatminmin.locationprovidertest I/location test: 6.0
08-16 15:43:27.152 25860-25860/com.fatminmin.locationprovidertest I/location test: 56.0
08-16 15:43:27.152 25860-25860/com.fatminmin.locationprovidertest I/location test: 61.0
08-16 15:43:27.152 25860-25860/com.fatminmin.locationprovidertest I/location test: 9.0
08-16 15:43:27.152 25860-25860/com.fatminmin.locationprovidertest I/location test: 4.0
08-16 15:43:27.153 25860-25860/com.fatminmin.locationprovidertest I/location test: 26.0
08-16 15:43:27.153 25860-25860/com.fatminmin.locationprovidertest I/location test: 52.0
08-16 15:43:27.153 25860-25860/com.fatminmin.locationprovidertest I/location test: 23.0
```