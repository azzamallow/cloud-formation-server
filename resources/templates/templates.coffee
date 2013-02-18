s3 = require '../../lib/s3'

exports.all = (req, res, next) ->
  s3.get next, (templates) ->
    res.send templates.map (template) -> template['Key']