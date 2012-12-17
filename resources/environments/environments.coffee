@cloudformation = require('aws2js').load('cloudformation', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET)

# CREATE_IN_PROGRESS | CREATE_FAILED | CREATE_COMPLETE | ROLLBACK_IN_PROGRESS | 
# ROLLBACK_FAILED | ROLLBACK_COMPLETE | DELETE_IN_PROGRESS | DELETE_FAILED | 
# DELETE_COMPLETE | UPDATE_IN_PROGRESS | UPDATE_COMPLETE_CLEANUP_IN_PROGRESS | 
# UPDATE_COMPLETE | UPDATE_ROLLBACK_IN_PROGRESS | UPDATE_ROLLBACK_FAILED | 
# UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS | UPDATE_ROLLBACK_COMPLETE

exports.all = (req, res) =>
    environmentName = process.env.ENVIRONMENT_NAME
    query = {
        'StackStatusFilter.member.1': 'CREATE_COMPLETE',
        'StackStatusFilter.member.2': 'CREATE_IN_PROGRESS'
    }

    @cloudformation.setRegion process.env.AWS_REGION
    @cloudformation.request 'ListStacks', query, (error, result) ->
        if error?
            res.writeHead 500 
            res.end 'Error occured. Sorry'
            return

        members = result['ListStacksResult']['StackSummaries']['member']

        res.send members.filter (member) -> member['StackName'].match "-#{environmentName}$"

exports.get = (req, res) ->
    

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