# serverless-awslambda-container

Create an AWS Lambda powered API endpoint using a custom build Ubuntu base image for ECR container.

## Getting Started

Install [serverless framework](https://www.serverless.com/framework/docs/getting-started) via NPM or as a standalone
binary.

```shell
$ sls --version
Framework Core: 3.31.0
Plugin: 6.2.3
SDK: 4.3.2
```

You should also have permissions to deploy to AWS Lambda, ECR, Cloudwatch, S3, and create IAM Lambda execution role.

Create an environment file `.env` with AWS profile infomation.

The sample `.env` file below also has environment vars necessary for currect serverless.yml.

```shell
AWS_PROFILE="my-profile-name"
AWS_REGION="us-east-1"
ENVIRON_VARIABLE_1="HelloWorld"
TAG_MANAGED_BY="email@example.com"
TAG_COST_CENTER="12345-05432"
```

## Deploy

Add AWS credentials to `~/.aws/credentials` 

To build container from dockerfile and deploy to ecr for lambda

```shell
sls deploy
```

To remove everything created by serverless
```shell
sls remove
```

Make sure to save the `.serverless` directory as it contains JSON statefiles which are helpful for future updates.

## Writing the application

The Dockerfile will copy over everything in the `app` directory and install python requirements from `requirements.txt`

```dockerfile
# Copy function code
COPY ./app/ ${LAMBDA_TASK_ROOT}/

# Install function dependencies
COPY requirements.txt /
RUN pip install \
    -r "/requirements.txt" \
    --target "${LAMBDA_TASK_ROOT}"
```

You can add additional dependencies and build up your code within the `app` directory. 

Lambda supports container images upto 10GB in size.


Best of luck!
