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
  name=${1}
  port=${2}

  aws ec2 authorize-security-group-ingress \
    --group-name ${name} \
    --protocol tcp \
    --port ${port} \
    --cidr 0.0.0.0/0
}
