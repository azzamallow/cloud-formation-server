@express = require 'express'
@app = @express()

@app.use @express.bodyParser()

@environment = require './environment'
@template = require './template'

@template.init @app
@environment.init @app

@app.listen 3000
console.log 'Listening on port 3000'