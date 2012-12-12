exports.index = (req, res) ->
    res.send [
        'rails-single-instance.template', 'rails-multi-az.template'
    ]
