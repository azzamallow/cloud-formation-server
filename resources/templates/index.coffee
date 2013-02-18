exports.connect = (app) ->
    app.get '/templates', require('./templates').all
