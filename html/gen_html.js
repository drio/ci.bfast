#!/usr/bin/env node

var jade = require('jade');

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

jade.renderFile('index.jade', options, function(err, html) {
  if (err) throw err;
  console.log(html);
});
