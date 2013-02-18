exports.eachPair = (object, callback) ->
    index = 1
    for key, value of object
        callback key, value, index
        index++