# init
express = require 'express'
app = express()

# configure
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.logger()
app.use express.methodOverride()
app.use app.router
app.use (err, req, res, next) ->
  console.error(err.stack)
  res.send(500, 'Something broke!')

# connect
require('./resources/environments').connect app
require('./resources/templates'   ).connect app

# start
app.listen 3000
console.log 'Listening on port 3000'