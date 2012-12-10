@express = require 'express'
@app = @express()

@app.use @express.bodyParser()

@environment = require './environment'

@environment.init @app

@app.listen 3000
console.log 'Listening on port 3000'