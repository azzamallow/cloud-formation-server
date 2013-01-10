module.exports = (api, action, query, callback) => 
    api.request action, query, (error, result) =>
        if error?
            res.writeHead 500 
            res.end 'Error occured. Sorry'
            return

        callback result