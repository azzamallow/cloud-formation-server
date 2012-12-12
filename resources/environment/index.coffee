@environment = require './environment.coffee'

exports.connect = (app) ->
    app.get     '/environment',             @environment.index
    app.get     '/environment/:id',         @environment.get
    app.put     '/environment/:id',         @environment.put
    app.post    '/environment/:id',         @environment.post
    app.delete  '/environment/:id',         @environment.delete

    app.put     '/environment/:id/start',   @environment.start
    app.put     '/environment/:id/stop',    @environment.stop
    app.put     '/environment/:id/reboot',  @environment.reboot