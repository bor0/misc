var
  util = require('util'),
  gfsfile = require('../gfsfile');

var db = new Object();
db.hostname = '127.0.0.1'
db.port = 27017
db.database = 'test'

x = gfsfile.getGfsFile(db, 'clipcanvas_14348_offline.mp4', 0, 3144689);

var fs = require('fs');
fs.writeFile("/tmp/test", x, function(err) {
    if(err) {
        console.log(err);
    } else {
        console.log("The file was saved!");
    }
}); 
