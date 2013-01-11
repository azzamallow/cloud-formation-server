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

    stackName = "#{req.params.id}-#{environmentName}"
    
    cloudformation.describeStacks stackName, handleError, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', handleError, (resources) ->
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
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    stackName = "#{req.params.id}-#{environmentName}"

    cloudformation.updateStack stackName, templateName, res.body, handleError, () ->
        res.send req.body

exports.post = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    stackName = "#{req.params.id}-#{environmentName}"

    cloudformation.createStack stackName, templateName, res.body, handleError, () ->
        res.send req.body

exports.delete = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    stackName = "#{req.params.id}-#{environmentName}"

    cloudformation.createStack stackName, templateName, res.body, handleError, () ->
        res.send ''

exports.start = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    stackName = "#{req.params.id}-#{environmentName}"
    
    cloudformation.describeStacks stackName, handleError, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', handleError, (resources) ->
            ec2.startInstances resources, handleError, () -> res.send ''

exports.stop = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    stackName = "#{req.params.id}-#{environmentName}"
    
    cloudformation.describeStacks stackName, handleError, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', handleError, (resources) ->
            ec2.stopInstances resources, handleError, () -> res.send ''

exports.reboot = (req, res) ->
    handleError = (error) ->
        res.send error.code, error.document['Error']['Message']

    stackName = "#{req.params.id}-#{environmentName}"
    
    cloudformation.describeStacks stackName, handleError, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', handleError, (resources) ->
            ec2.rebootInstances resources, handleError, () -> res.send ''