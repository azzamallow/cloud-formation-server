api = require 'aws2js'
s3  = api.
      load('s3', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
      setBucket(process.env.BUCKET_NAME)

exports.get = (errorCallback, callback) ->
    s3.get '/', 'xml', (error, result) ->
        errorCallback(error) if error?
        callback result
