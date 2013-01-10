api             = require 'aws2js'
cloudformation  = api.
                  load('cloudformation', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                  setRegion(process.env.AWS_REGION)

exports.listStacks = (environmentName, errorCallback, callback) ->
    query = {
        'StackStatusFilter.member.1': 'CREATE_COMPLETE',
        'StackStatusFilter.member.2': 'CREATE_IN_PROGRESS'
    }

    cloudformation.request 'ListStacks', query, (error, result) ->
        errorCallback(error) if error?
        members = result['ListStacksResult']['StackSummaries']['member']
        stacks  = members.filter (member) => member['StackName'].match "-#{environmentName}$"
        callback stacks

exports.describeStacks = (id, environmentName, errorCallback, callback) ->
    query = {
        'StackName': "#{id}-#{environmentName}"
    }

    cloudformation.request 'DescribeStacks', query, (error, result) ->
        errorCallback(error) if error?
        member = result['DescribeStacksResult']['Stacks']['member'] if result?
        callback member

exports.listStackResources = (id, environmentName, resourceType, errorCallback, callback) ->
    query = {
        'StackName': "#{id}-#{environmentName}"
    }

    cloudformation.request 'ListStackResources', query, (error, result) ->
        errorCallback(error) if error?
        members   = result['ListStackResourcesResult']['StackResourceSummaries']['member']
        resources = members.filter (member) => member['ResourceType'] == resourceType
        callback resources