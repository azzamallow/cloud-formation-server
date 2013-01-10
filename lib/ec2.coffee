api     = require 'aws2js'
ec2     = api.
          load('ec2', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
          setRegion(process.env.AWS_REGION)

exports.describeInstanceStatus = (resources, errorCallback, callback) ->
    query = {
        'IncludeAllInstances': true
    }

    count = 1
    for resource in resources
        query["InstanceId.#{count}"] = resource['PhysicalResourceId']
        count++

    ec2.request 'DescribeInstanceStatus', query, (error, result) ->
        errorCallback() if error?
        items = result['instanceStatusSet']['item']
        items = [items] unless items.length
        callback items