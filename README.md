
tibeacon
===========================================

A *very* quick and dirty iOS Titanium module to make your app advertise an an iBeacon. 



See /example/app.js for a full test app with adjustable major/minor values. 




REGISTER THE MODULE
--------------------

Register the module with your application by editing `tiapp.xml` and adding:

	<module platform="iphone">com.kosso.tibeacon</module>
### IMPORTANT

**DONT FORGET: Add the Bluetooth usage description to tiapp.xml in the <ios> section!! **

**Or you will crash. Hard.** 

```
<key>NSBluetoothPeripheralUsageDescription</key>
<string>To be a beacon!</string>
```



**************************************************************




USING THE MODULE
-------------------------

	var tibeacon = require('com.kosso.tibeacon');

	// Methods

	tibeacon.isAdvertising(); // boolean

	tibeacon.startAdvertising();

	// major.minor range is 0 - 65535
	tibeacon.minor = 4;
	tibeacon.major = 10;
	tibeacon.setMajor(1); 
	tibeacon.setMinor(10);
	
	tibeacon.startAdvertising({
	  major:1,
	  minor:6
	});
	
	tibeacon.stopAdvertising();




## TO DO 

- Set custom GUID. (Currently uses the module's one).
- Set power. 
- .. get this added to other modules that don't support advertising ;) 




-------

@kosso : March 2017