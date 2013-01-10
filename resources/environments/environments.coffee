cloudformation  = require '../../lib/cloudformation',
ec2             = require '../../lib/ec2',
environmentName = process.env.ENVIRONMENT_NAME

exports.all = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message'] 

    cloudformation.listStacks environmentName, handleError, (stacks) ->
        res.send stacks.map (stack) -> {
            id:           stack['StackName'].match("(.*)-#{environmentName}$")[1],
            status:       stack['StackStatus'],
            creationTime: stack['CreationTime']
        }

exports.get = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    cloudformation.describeStacks req.params.id, environmentName, handleError, (stack) ->
        cloudformation.listStackResources req.params.id, environmentName, 'AWS::EC2::Instance', handleError, (resources) ->
            ec2.describeInstanceStatus resources, handleError, (instances) ->
                res.send {
                    id:           req.params.id,
                    status:       stack['StackStatus'],
                    creationTime: stack['CreationTime'],
                    instances:    instances.map (instance) -> {
                        instance: instance['instanceId'],
                        status:   instance['instanceState']['name']
                    }
                }

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