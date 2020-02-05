# cloudformation-ec2-cluster


Use Bastion as the SSH jump host to reach private instances.
```bash
BASTION_HOST=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=Public-Node-Bastion' --output text --query 'Reservations[].Instances[].PublicIpAddress')
ssh -o ForwardAgent=yes -o ProxyCommand="ssh -q -W %h:%p ec2-user@${BASTION_HOST}" ec2-user@xx.x.x.xxx
```
