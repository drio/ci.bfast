#!/usr/bin/env node

var fs   = require('fs');
var jade = require('jade');
var _    = require('underscore');

/*
var options = {
    locals: {
        entries: {
          "ts1" : {
            "lucid32" : { "bfast": 0, "bfast_bwa": 0,  }, 
            "lucid64" : { "bfast": 1, "bfast_bwa": 1,  },
            "darwin"  : { "bfast": 2, "bfast_bwa": 2,  }, 
          },
          "ts2" : {
            "lucid32" : { "bfast": 10, "bfast_bwa": 10,  },
            "lucid64" : { "bfast": 11, "bfast_bwa": 11,  },
            "darwin"  : { "bfast": 12, "bfast_bwa": 12,  },
          },
        }
    }
};
*/

fs.readdir("../logs", function(err, files) {
  if (err) throw err;
  var log_files = _.select(files, function(f) {
    return /log\.\d+\.log$/.test(f);
  });

  var entries = {};

  _.each(log_files, function(f) {
    var re = /(\w+).([\w-]+).(\d+).(\d+).(\d+).(\d+).(\d+).(\d+).log.(\d+)/;
    var m  = re.exec(f);
    var box = m[1], branch = m[2], 
        day = m[3], month  = m[4], year = m[5], hour = m[6], min = m[7],
        ts  = m[8], e_status = m[9];
    if (!entries[ts]) { entries[ts] = {};}
    if (!entries[ts][box]) { entries[ts][box] = {};}
    entries[ts][box][branch] = e_status;
  });

  var options = {};
  options.locals = {};
  options.locals.entries = entries; 
  //console.log(entries);
  jade.renderFile('index.jade', options, function(err, html) {
    if (err) throw err;
    console.log(html);
  });
});
