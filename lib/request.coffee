exports.for = (api) ->
  (method, query, next, callback) ->
    api.request method, query, (error, result) ->
        if error?
            next error
        else
            callback result