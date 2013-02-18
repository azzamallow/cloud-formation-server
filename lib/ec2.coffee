api = require 'aws2js'
ec2 = api.
      load('ec2', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
      setRegion(process.env.AWS_REGION)

exports.describeInstanceStatus = (resources, next, callback) ->
    query = 'IncludeAllInstances': true

    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    request 'DescribeInstanceStatus', query, next, (result) ->
        items = result['instanceStatusSet']['item']
        items = [].concat items
        callback items

exports.startInstances = (resources, next) ->
    query = {}
    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    request 'StartInstances', query, next, callback

exports.stopInstances = (resources, next) ->
    query = {}
    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    request 'StopInstances', query, next, callback

exports.rebootInstances = (resources, next) ->
    query = {}
    for resource, i in resources
        query["InstanceId.#{i}"] = resource['PhysicalResourceId']

    request 'RebootInstances', query, next, callback

request = (method, query, next, callback) ->
    ec2.request method, query, (error, result) ->
        if error?
            next error
        else
            callback result