# Set some defaults
ARG LAMBDA_TASK_ROOT="/app"
ARG LAMBDA_RUNTIME_DIR="/usr/local/bin"
ARG PLATFORM="linux/amd64"

# Get a base image
FROM public.ecr.aws/ubuntu/ubuntu:22.04

# Set env vars for aws lambda
ENV LAMBDA_TASK_ROOT="${LAMBDA_TASK_ROOT}"
ENV LAMBDA_RUNTIME_DIR="${LAMBDA_RUNTIME_DIR}"

# Install aws-lambda-cpp build dependencies
RUN apt-get -qq update && \
    apt-get -qq install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev \
    python3 \
    python3-pip \
    python-is-python3

# Install the runtime interface client
RUN pip install  \
    awslambdaric \
    --target "${LAMBDA_TASK_ROOT}"

# Copy function code
COPY ./app/ ${LAMBDA_TASK_ROOT}/

# Install function dependencies
COPY requirements.txt /
RUN pip install \
    -r "/requirements.txt" \
    --target "${LAMBDA_TASK_ROOT}"

# Add python path to /usr/local/bin for lambda
RUN update-alternatives --install "/usr/local/bin/python" python "/usr/bin/python3" 2

# (Optional) Add Lambda Runtime Interface Emulator and use a script in the ENTRYPOINT for simpler local runs
WORKDIR ${LAMBDA_TASK_ROOT}
ADD "https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie" "/usr/bin/aws-lambda-rie"
COPY entry.sh /
RUN chmod 755 "/usr/bin/aws-lambda-rie" "/entry.sh"


ENTRYPOINT [ "/entry.sh" ]
CMD [ "app.handler" ]