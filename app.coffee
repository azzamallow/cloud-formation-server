# init
express = require 'express'
@app = express()

# configure
@app.use express.bodyParser()

# connect
require('./resources/environments').connect @app
require('./resources/templates'   ).connect @app

# start
@app.listen 3000
console.log 'Listening on port 3000'