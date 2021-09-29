#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')

cat test-pod.yaml.template | sed "s/ACCOUNT_ID/$ACCOUNT_ID/" > test-pod.yaml

