/*

tibeacon test app.js
Author : Kosso
Date: March 2017

**************************************************************
DONT FORGET: Add the usage description to tiapp.xml in the <ios> section!! Or you will crash. Hard. 

<key>NSBluetoothPeripheralUsageDescription</key>
<string>To be a beacon!</string>
    
**************************************************************            
*/


var tibeacon = require('com.kosso.tibeacon');

console.log('tibeacon: ', tibeacon);

// open a single window
var window = Ti.UI.createWindow({
  backgroundColor:'#3572bd'
});

var scroller = Ti.UI.createScrollView({top:20, left:0, right:0, zIndex:1, bottom:0, contentHeight:Ti.UI.SIZE, scrollType:'vertical', layout:'vertical'});

var label = Ti.UI.createLabel({
  text:'tibeacon!',
  top:40,
  font:{fontSize:40},
  color:'white',
  height:Ti.UI.SIZE,
  width:Ti.UI.SIZE
});
scroller.add(label);


var slider_major = Titanium.UI.createSlider({
  top: 30,
  min: 0,
  max: 100,//65535,
  left: 20,
  right: 20,
  value: 0
});
scroller.add(slider_major)

var value_major = Ti.UI.createLabel({
  text:'major: ' + Math.round(slider_major.value),
  top:10,
  color:'white',
  height:Ti.UI.SIZE,
  width:Ti.UI.SIZE
});
scroller.add(value_major)

slider_major.addEventListener('change', function(e){
  value_major.text ='major: ' + Math.round(e.value); 
});

slider_major.addEventListener('stop', function(e){
  value_major.text ='major: ' + Math.round(e.value); 
  if(tibeacon.isAdvertising()){
    tibeacon.updateMajorMinor({
      major:Math.round(e.value),
      minor:Math.round(slider_minor.value)
    });
  } else {
    tibeacon.major = Math.round(e.value);
  }
});



var slider_minor = Titanium.UI.createSlider({
  top: 60,
  min: 0,
  max: 100,//65535,
  left: 20,
  right: 20,
  value: 0
});

scroller.add(slider_minor)

var value_minor = Ti.UI.createLabel({
  text:'minor: ' + Math.round(slider_minor.value),
  top:10,
  color:'white',
  height:Ti.UI.SIZE,
  width:Ti.UI.SIZE
});
scroller.add(value_minor)

slider_minor.addEventListener('change', function(e){
  value_minor.text = 'minor: '+Math.round(e.value); 
});
slider_minor.addEventListener('stop', function(e){
  value_minor.text ='minor: ' + Math.round(e.value); 
  if(tibeacon.isAdvertising()){
    tibeacon.updateMajorMinor({
      minor:Math.round(e.value),
      major:Math.round(slider_major.value)
    });
  } else {
    tibeacon.minor = Math.round(e.value);
  }
});



var btn_beacon = Ti.UI.createButton({
  width:200,
  borderColor:'#ccc',
  borderWidth:1,
  top:60,
  height:50,
  backgroundColor:'white',
  borderRadius:25,
  borderColor:'#2d598f',
  borderWidth:3,
  color:'#3572bd',
  tintColor:'#3572bd',
  title:'start beacon'
});

function guid() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    s4() + '-' + s4() + s4() + s4();
}

btn_beacon.addEventListener('click', function(e){

  //console.log('beacon:  isAdvertising: ' + tibeacon.isAdvertising());

  if(!tibeacon.isAdvertising()){
    
    //tibeacon.startAdvertising();

    console.log('beacon: startAdvertising');
    
    tibeacon.startAdvertising({
      minor:Math.round(slider_minor.value),
      major:Math.round(slider_major.value),
      uuid:'ffffffff-ffff-ffff-ffff-ffffffffffff',
      identifier:'TestBeacon'
    });


    btn_beacon.title = 'stop beacon';

    //slider_minor.enabled = false;
    //slider_major.enabled = false;

  } else {

    console.log('beacon: stopAdvertising');

    tibeacon.stopAdvertising();
    btn_beacon.title = 'start beacon';

    //slider_minor.enabled = true;
    //slider_major.enabled = true;

  }

});
scroller.add(btn_beacon);


// ;) 

var label = Ti.UI.createLabel({
  text:'by @kosso',
  top:60,
  font:{fontSize:10},
  color:'#93b0d4',
  height:Ti.UI.SIZE,
  width:Ti.UI.SIZE
});
scroller.add(label)


window.add(scroller);

window.open();

