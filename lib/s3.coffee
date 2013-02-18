api = require 'aws2js'
s3  = api.
      load('s3', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
      setBucket(process.env.BUCKET_NAME)

exports.get = (errorCallback, callback) ->
    request '/', (result) ->
        response = []
        response = [].concat result['Contents'] if result['Contents']
        callback response

exports.getObject = (objectName, errorCallback, callback) ->
    request "/#{objectName}", (result) ->
        callback result['Contents']

request = (path, next, callback) ->
    s3.get method, 'xml', (error, result) ->
        if error?
            next error
        else
            callback result