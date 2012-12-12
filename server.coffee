# init
express = require 'express'
@app = express()

# configure
@app.use express.bodyParser()

# connect
require('./resources/environment').connect @app
require('./resources/template')   .connect @app

# start
@app.listen 3000
console.log 'Listening on port 3000'