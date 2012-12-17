@templates = require './templates.coffee'

exports.connect = (app) ->
    app.get '/templates', @templates.all