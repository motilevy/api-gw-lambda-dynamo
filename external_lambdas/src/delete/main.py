#!/usr/bin/env python3
import json
import boto3
import os

def lambda_handler(event, context):
    lambda_client = boto3.client("lambda")
    response = lambda_client.invoke(
        FunctionName='delete-internal-{}'.format(os.environ['NAME']),
        InvocationType='RequestResponse',
        LogType='None',
        Payload=event['body']
    )
    d = response['Payload'].read()

    return {
        "statusCode": 200,
        "body": json.dumps(d.decode('utf-8'))
    }
