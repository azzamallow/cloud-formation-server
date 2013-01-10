@cloudformation  = require('aws2js').
                    load('cloudformation', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                    setRegion(process.env.AWS_REGION)

@ec2  = require('aws2js').
                    load('ec2', process.env.ACCESS_KEY, process.env.ACCESS_KEY_SECRET).
                    setRegion(process.env.AWS_REGION)

@environmentName = process.env.ENVIRONMENT_NAME

# CREATE_IN_PROGRESS | CREATE_FAILED | CREATE_COMPLETE | ROLLBACK_IN_PROGRESS | 
# ROLLBACK_FAILED | ROLLBACK_COMPLETE | DELETE_IN_PROGRESS | DELETE_FAILED | 
# DELETE_COMPLETE | UPDATE_IN_PROGRESS | UPDATE_COMPLETE_CLEANUP_IN_PROGRESS | 
# UPDATE_COMPLETE | UPDATE_ROLLBACK_IN_PROGRESS | UPDATE_ROLLBACK_FAILED | 
# UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS | UPDATE_ROLLBACK_COMPLETE

exports.all = (req, res) =>
    query = {
        'StackStatusFilter.member.1': 'CREATE_COMPLETE',
        'StackStatusFilter.member.2': 'CREATE_IN_PROGRESS'
    }

    @cloudformation.request 'ListStacks', query, (error, result) =>
        if error?
            res.writeHead 500 
            res.end 'Error occured. Sorry'
            return

        members = result['ListStacksResult']['StackSummaries']['member']

        filtered = members.filter (member) => member['StackName'].match "-#{@environmentName}$"

        environments = filtered.map (member) => {
            id:           member['StackName'].match("(.*)-#{@environmentName}$")[1],
            status:       member['StackStatus'],
            creationTime: member['CreationTime']
        }

        res.send environments

exports.get = (req, res) =>
    query = {
        'StackName': "#{req.params.id}-#{@environmentName}"
    }

    @cloudformation.request 'DescribeStacks', query, (error, result) =>
        if error?
            res.writeHead 500 
            res.end 'Error occured. Sorry'
            return

        member = result['DescribeStacksResult']['Stacks']['member']

        environment = {
            id:           req.params.id,
            status:       member['StackStatus'],
            creationTime: member['CreationTime']
        }

        @cloudformation.request 'ListStackResources', query, (error, result) =>
            if error?
                res.writeHead 500 
                res.end 'Error occured. Sorry'
                return

            members = result['ListStackResourcesResult']['StackResourceSummaries']['member']

            filtered = members.filter (member) => member['ResourceType'] == 'AWS::EC2::Instance'

            instance_query = {
                'IncludeAllInstances': true
            }

            count = 1
            for member in filtered
                instance_query["InstanceId.#{count}"] = member['PhysicalResourceId']
                count++

            @ec2.request 'DescribeInstanceStatus', instance_query, (error, result) =>
                if error?
                    res.writeHead 500 
                    res.end 'Error occured. Sorry'
                    return

                items = result['instanceStatusSet']['item']
                res.send environment unless items?

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