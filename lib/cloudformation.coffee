request         = require './api-request'
api             = require 'aws2js'
cloudformation  = api.
                  load('cloudformation', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                  setRegion(process.env.AWS_REGION)

# CREATE_IN_PROGRESS | CREATE_FAILED | CREATE_COMPLETE | ROLLBACK_IN_PROGRESS | 
# ROLLBACK_FAILED | ROLLBACK_COMPLETE | DELETE_IN_PROGRESS | DELETE_FAILED | 
# DELETE_COMPLETE | UPDATE_IN_PROGRESS | UPDATE_COMPLETE_CLEANUP_IN_PROGRESS | 
# UPDATE_COMPLETE | UPDATE_ROLLBACK_IN_PROGRESS | UPDATE_ROLLBACK_FAILED | 
# UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS | UPDATE_ROLLBACK_COMPLETE

exports.listStacks = (environmentName, callback) ->
    query = {
        'StackStatusFilter.member.1': 'CREATE_COMPLETE',
        'StackStatusFilter.member.2': 'CREATE_IN_PROGRESS'
    }

    request cloudformation, 'ListStacks', query, (result) =>
        members = result['ListStacksResult']['StackSummaries']['member']
        stacks = members.filter (member) => member['StackName'].match "-#{environmentName}$"
        callback stacks

# exports.describeStacks = (environmentName, callback) ->
    