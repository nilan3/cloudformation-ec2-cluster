# cloudformation-ec2-cluster

![Alt text](architecture.jpg?raw=true "Kubernetes Dashboard")

## Usage
1. Create your EC2 key on the AWS console and save pem file in your local directory.
2. Update `REGION`, `EC2_KEY_NAME`, `EC2_AMI_ID` as appropriate.
3. Deploy cloudformation set up stack
```bash
bash scripts/cfn-deploy.sh setup
```
4. Navigate to the CloudFormation section on the AWS console and execute the changeset created for the setup-stack.
3. Once setup stack is deployed, run master stack.deployment.
```bash
bash scripts/cfn-deploy deploy
```
4. Navigate to the CloudFormation section on the AWS console again and execute the changeset created for the master-stack.
5. Wait for deployment to complete then check the node IPs on the EC2 section of the AWS console.

Use Bastion as the SSH jump host to reach private instances.
```bash
ssh-agent bash
ssh-add ${PATH_TO_PEM_FILE}
BASTION_HOST=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=Public-Node-Bastion' --output text --query 'Reservations[].Instances[].PublicIpAddress')
ssh -o ForwardAgent=yes -o ProxyCommand="ssh -q -W %h:%p ec2-user@${BASTION_HOST}" ec2-user@xx.x.x.xxx
```
