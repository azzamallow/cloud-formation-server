@environments = require './environments.coffee'

exports.connect = (app) ->
    app.get     '/environments',             @environments.all
    app.get     '/environments/:id',         @environments.get
    app.put     '/environments/:id',         @environments.put
    app.post    '/environments/:id',         @environments.post
    app.delete  '/environments/:id',         @environments.delete

    app.put     '/environments/:id/start',   @environments.start
    app.put     '/environments/:id/stop',    @environments.stop
    app.put     '/environments/:id/reboot',  @environments.reboot