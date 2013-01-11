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

exports.describeStacks = (stackName, errorCallback, callback) ->
    query = {
        'StackName': stackName
    }

    cloudformation.request 'DescribeStacks', query, (error, result) ->
        errorCallback(error) if error?
        member = result['DescribeStacksResult']['Stacks']['member'] if result?
        callback member

exports.listStackResources = (stackName, resourceType, errorCallback, callback) ->
    query = {
        'StackName': stackName
    }

    cloudformation.request 'ListStackResources', query, (error, result) ->
        errorCallback(error) if error?
        members   = result['ListStackResourcesResult']['StackResourceSummaries']['member']
        resources = members.filter (member) => member['ResourceType'] == resourceType
        callback resources

exports.createStack = (stackName, templateBody, templateParams, errorCallback, callback) ->
    query = {
        'StackName': stackName,
        'TemplateBody': templateBody,
    }

    count = 1
    for key, value of templateParams
        query["Parameters.member.#{i}.ParameterKey"] = key
        query["Parameters.member.#{i}.ParameterValue"] = value
        count++

    cloudformation.request 'CreateStack', query, (error, result) ->
        errorCallback(error) if error?
        callback()

exports.updateStack = (stackName, templateBody, templateParams, errorCallback, callback) ->
    query = {
        'StackName': stackName,
        'TemplateBody': templateBody,
    }

    count = 1
    for key, value of templateParams
        query["Parameters.member.#{i}.ParameterKey"] = key
        query["Parameters.member.#{i}.ParameterValue"] = value
        count++

    cloudformation.request 'UpdateStack', query, (error, result) ->
        errorCallback(error) if error?
        callback()    

exports.deleteStack = (stackName, errorCallback, callback) ->
    query = {
        'StackName': stackName
    }

    cloudformation.request 'DeleteStack', query, (error, result) ->
        errorCallback(error) if error?
        callback()