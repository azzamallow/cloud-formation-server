@template = require './template.coffee'

exports.connect = (app) ->
    app.get '/template', @template.all