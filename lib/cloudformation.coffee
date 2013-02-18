api             = require 'aws2js'
cloudformation  = api.
                  load('cloudformation', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                  setRegion(process.env.AWS_REGION)
request         = require('./request').for(cloudformation)
Array           = require('./array')

exports.listStacks = (environmentName, next, callback) ->
    query = 'StackStatusFilter.member.1': 'CREATE_COMPLETE', 'StackStatusFilter.member.2': 'CREATE_IN_PROGRESS'

    request 'ListStacks', query, next, (result) ->
        members = result['ListStacksResult']['StackSummaries']['member'] || []
        stacks  = members.filter (member) -> member['StackName'].match "-#{environmentName}$"
        callback stacks

exports.describeStacks = (stackName, next, callback) ->
    query = 'StackName': stackName

    request 'DescribeStacks', query, next, (result) ->
        member = result['DescribeStacksResult']['Stacks']['member'] if result?
        callback member

exports.listStackResources = (stackName, resourceType, next, callback) ->
    query = 'StackName': stackName

    request 'ListStackResources', query, next, (result) ->
        members   = result['ListStackResourcesResult']['StackResourceSummaries']['member']
        resources = members.filter (member) -> member['ResourceType'] == resourceType
        callback resources

exports.createStack = (stackName, templateBody, templateParams, next, callback) ->
    query = 'StackName': stackName, 'TemplateBody': templateBody

    Array.eachPair templateParams, (key, value, index) -> 
        query["Parameters.member.#{index}.ParameterKey"] = key
        query["Parameters.member.#{index}.ParameterValue"] = value

    request 'CreateStack', query, next, callback

exports.updateStack = (stackName, templateBody, templateParams, next, callback) ->
    query = 'StackName': stackName, 'TemplateBody': templateBody

    Array.eachPair templateParams, (key, value, index) -> 
        query["Parameters.member.#{index}.ParameterKey"] = key
        query["Parameters.member.#{index}.ParameterValue"] = value

    request 'UpdateStack', query, next, callback

exports.deleteStack = (stackName, next, callback) ->
    query = 'StackName': stackName
    request 'DeleteStack', query, next, callback