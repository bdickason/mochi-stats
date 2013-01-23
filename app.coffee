express = require 'express'
Db = (require './lib/db.js').Db
cfg = require './cfg/config.js'

app = express()
app.use express.bodyParser()
app.use express.cookieParser()


### Initialize DB ###
db = new Db cfg

### Controllers ###

### Routes ###      

### Start the App ###
app.listen "#{cfg.PORT}"
