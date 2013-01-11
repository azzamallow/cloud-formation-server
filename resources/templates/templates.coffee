s3 = require '../../lib/s3'

exports.all = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message'] 

    s3.get handleError, (templates) ->
        res.send templates['Contents'].map (template) -> template['Key']