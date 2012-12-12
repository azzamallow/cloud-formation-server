@s3 = require('aws2js').load('s3', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET)

exports.all = (req, res) =>
    @s3.get '/', {uploads: null, 'max-uploads': 1}, 'xml', (error, result) ->
        if error?
            res.writeHead 500 
            res.end 'Error occured. Sorry'
            return
        
        res.send [
            'rails-single-instance.template', 
            'rails-multi-az.template',
            process.env.ACCESS_KEY,
            process.env.ACCESS_KEY_SECRET
        ] 
