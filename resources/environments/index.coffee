exports.connect = (app) ->
    app.get     '/environments',             require('./environments').all
    app.get     '/environments/:id',         require('./environments').get
    app.put     '/environments/:id',         require('./environments').put
    app.post    '/environments/:id',         require('./environments').post
    app.delete  '/environments/:id',         require('./environments').delete
    app.put     '/environments/:id/start',   require('./environments').start
    app.put     '/environments/:id/stop',    require('./environments').stop
    app.put     '/environments/:id/reboot',  require('./environments').reboot