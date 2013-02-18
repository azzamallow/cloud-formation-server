cloudformation  = require '../../lib/cloudformation',
ec2             = require '../../lib/ec2',
environmentName = process.env.ENVIRONMENT_NAME

exports.all = (req, res, next) ->
    cloudformation.listStacks environmentName, next, (stacks) ->
        res.send stacks.map (stack) ->
            id:           stack['StackName'].match("(.*)-#{environmentName}$")[1],
            status:       stack['StackStatus'],
            creationTime: stack['CreationTime']

exports.get = (req, res, next) ->
    stackName = "#{req.params.id}-#{environmentName}"
    cloudformation.describeStacks stackName, next, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', next, (resources) ->
            ec2.describeInstanceStatus resources, next, (instances) ->
                res.send
                    id:           req.params.id,
                    status:       stack['StackStatus'],
                    creationTime: stack['CreationTime'],
                    instances:    instances.map (instance) ->
                        instance: instance['instanceId'],
                        status:   instance['instanceState']['name']

exports.put = (req, res, next) ->
    stackName      = "#{req.params.id}-#{environmentName}"
    templateParams = res.body
    templateName   = req.params.templateName

    s3.getObject templateName, next, (templateObject) ->
        cloudformation.updateStack stackName, templateObject, templateParams, next, () ->
            res.send req.body

exports.post = (req, res, next) ->
    stackName      = "#{req.params.id}-#{environmentName}"
    templateParams = res.body
    templateName   = req.params.templateName

    s3.getObject templateName, next, (templateObject) ->
        cloudformation.createStack stackName, templateObject, templateParams, next, () ->
            res.send req.body

exports.delete = (req, res, next) ->
    stackName = "#{req.params.id}-#{environmentName}"
    cloudformation.deleteStack stackName, next, () -> res.send ''

exports.start = (req, res, next) ->
    stackName = "#{req.params.id}-#{environmentName}"
    cloudformation.describeStacks stackName, next, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', next, (resources) ->
            ec2.startInstances resources, next, () -> res.send ''

exports.stop = (req, res, next) ->
    stackName = "#{req.params.id}-#{environmentName}"
    cloudformation.describeStacks stackName, next, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', next, (resources) ->
            ec2.stopInstances resources, next, () -> res.send ''

exports.reboot = (req, res, next) ->
    stackName = "#{req.params.id}-#{environmentName}"
    cloudformation.describeStacks stackName, next, (stack) ->
        cloudformation.listStackResources stackName, 'AWS::EC2::Instance', next, (resources) ->
            ec2.rebootInstances resources, next, () -> res.send ''