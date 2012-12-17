exports.all = (req, res) ->
    res.send [
        'ci', 'canary', 'qa', 'production'
    ]

exports.get = (req, res) ->
    console.log 'getting details and status for the environment'
    res.send req.params.id

exports.put = (req, res) ->
    res.send [
        {params: req.body.phone}
    ]

exports.post = (req, res) ->
    res.send [
        {params: req.body.phone}
    ]

exports.delete = (req, res) ->
    console.log 'issued delete'
    res.send ''

exports.start = (req, res) ->
    console.log 'starting'
    res.send ''

exports.stop = (req, res) ->
    console.log 'stopping'
    res.send ''

exports.reboot = (req, res) ->
    console.log 'reboot'
    res.send ''