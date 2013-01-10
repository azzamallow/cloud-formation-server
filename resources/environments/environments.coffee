api             = require('aws2js')
cloudformation  = api.
                  load('cloudformation', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                  setRegion(process.env.AWS_REGION)
ec2             = api.
                  load('ec2', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                  setRegion(process.env.AWS_REGION)

cloudFormation = require '../../lib/cloudformation'

@request = require '../../lib/api-request'

@environmentName = process.env.ENVIRONMENT_NAME

exports.all = (req, res) =>
    cloudFormation.listStacks @environmentName, (stacks) =>
        environments = stacks.map (stack) => {
            id:           stack['StackName'].match("(.*)-#{@environmentName}$")[1],
            status:       stack['StackStatus'],
            creationTime: stack['CreationTime']
        }

        res.send environments

exports.get = (req, res) =>
    query = {
        'StackName': "#{req.params.id}-#{@environmentName}"
    }

    @request cloudformation, 'DescribeStacks', query, (result) =>
        member = result['DescribeStacksResult']['Stacks']['member']

        environment = {
            id:           req.params.id,
            status:       member['StackStatus'],
            creationTime: member['CreationTime']
        }

        @request cloudformation, 'ListStackResources', query, (result) =>
            members = result['ListStackResourcesResult']['StackResourceSummaries']['member']

            filtered = members.filter (member) => member['ResourceType'] == 'AWS::EC2::Instance'

            instance_query = {
                'IncludeAllInstances': true
            }

            count = 1
            for member in filtered
                instance_query["InstanceId.#{count}"] = member['PhysicalResourceId']
                count++

            @request ec2, 'DescribeInstanceStatus', instance_query, (result) =>
                items = result['instanceStatusSet']['item']
                items = [items] unless items.length

                environment.instances = items.map (item) => {
                    instance: item['instanceId'],
                    status:   item['instanceState']['name']
                }

                res.send environment

exports.put = (req, res) =>
    res.send [
        {params: req.body.phone}
    ]

exports.post = (req, res) =>
    res.send [
        {params: req.body.phone}
    ]

exports.delete = (req, res) =>
    console.log 'issued delete'
    res.send ''

exports.start = (req, res) =>
    console.log 'starting'
    res.send ''

exports.stop = (req, res) =>
    console.log 'stopping'
    res.send ''

exports.reboot = (req, res) =>
    console.log 'reboot'
    res.send ''