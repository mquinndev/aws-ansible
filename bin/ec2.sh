#!/bin/bash

function ec2-images() {
  aws ec2 describe-images \
    --filters \
      "Name=description,Values=Amazon Linux AMI * x86_64 HVM GP2" \
    --query \
      'Images[*].[CreationDate, Description, ImageId]' \
    --output text \
      | sort -k 1 \
      | tail
}

function ec2-create-security-group() {
  name=$1
  description="${name} security group"
  vpcid=$2

  aws ec2 create-security-group \
    --group-name ${name} \
    --description "${description}" \
    --vpc-id ${vpcid}
}

function ec2-inbound-security() {
  name=$1
  port=$2

  aws ec2 authorize-security-group-ingress \
    --group-name ${name} \
    --protocol tcp \
    --port ${port} \
    --cidr 0.0.0.0/0
}

function ec2-describe-security-groups() {
  name=$1

  aws ec2 describe-security-groups \
    --group-name ${name} \
    --output text
}

function ec2-create-key-pair() {
  key_name=$1

  aws ec2 create-key-pair \
    --key-name ${key_name}
}

function ec2-launch-instance() {
  instance_type=${1:-t2.micro}
  key_name=${2:-EffectiveDevOpsAWS}
  security_group_ids=${3:-sg-0748dfff4cc1dc5ba}
  image_id=${4:-ami-caaf84af}

  aws ec2 run-instances \
    --instance-type ${instance_type} \
    --key-name ${key_name} \
    --security-group-ids ${security_group_ids} \
    --image-id ${image_id}
}

function ec2-instance-status() {
  instance_id=${1}

  aws ec2 describe-instance-status \
    --instance-ids ${instance_id}
}

function ec2-describe-instances() {
  instance_id=${1}

  aws ec2 describe-instances \
    --instance-ids ${instance_id} \
    --query "Reservations[*].Instances[*].PublicDnsName"
}

function ec2-delete-instance() {
  instance_id=${1}

  aws ec2 terminate-instances \
   --instance-ids ${instance_id}
}
