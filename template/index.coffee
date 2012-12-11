@template = require './template.coffee'

exports.init = (app) ->
    app.get '/template/index', @template.index
