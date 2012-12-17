@s3 = require('aws2js').load('s3', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET)

exports.all = (req, res) =>
    @s3.setBucket 'dupondius_cf_templates'
    @s3.get '/', 'xml', (error, result) ->
        if error?
            res.writeHead 500 
            res.end 'Error occured. Sorry'
            return
        
        res.send result
