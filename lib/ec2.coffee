api = require 'aws2js'
ec2 = api.
      load('ec2', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
      setRegion(process.env.AWS_REGION)

exports.describeInstanceStatus = (resources, errorCallback, callback) ->
    query = 'IncludeAllInstances': true

    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    ec2.request 'DescribeInstanceStatus', query, (error, result) ->
        errorCallback(error) if error?
        items = result['instanceStatusSet']['item']
        items = [items] unless items.length
        callback items

exports.startInstances = (instanceId, handleError) ->
    query = {}
    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    ec2.request 'StartInstances', query, (error, result) ->
        errorCallback(error) if error?
        callback()

exports.stopInstances = (instanceId, handleError) ->
    query = {}
    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    ec2.request 'StopInstances', query, (error, result) ->
        errorCallback(error) if error?
        callback()

exports.rebootInstances = (instanceId, handleError) ->
    query = {}
    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    ec2.request 'RebootInstances', query, (error, result) ->
        errorCallback(error) if error?
        callback()