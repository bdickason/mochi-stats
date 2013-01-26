express = require 'express'
Db = (require './srv/lib/db.js').Db
cfg = require './cfg/config.js'

app = express()
app.use express.bodyParser()
app.use express.cookieParser()
app.set 'views', __dirname + '/srv/views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/client')

### Initialize DB ###
db = new Db cfg

### Controllers ###

### Client Routes ###      
app.get '/', (req, res) ->
  res.render 'index'

### API Routes ###
app.get '/customers', (req, res) ->
  db.getCustomers null, null, (err, callback) ->
    res.send callback

### Start the App ###
app.listen "#{cfg.PORT}"
