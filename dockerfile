# Use the Lambda Python 3.14 base image
FROM public.ecr.aws/lambda/python:3.12

# Amazon Linux 2023 uses dnf
RUN dnf -y install python3-devel gcc postgresql-devel zip && \
    dnf clean all

RUN python3 -m pip install --upgrade pip setuptools wheel

RUN mkdir -p /layer/python

# Install third-party libs into /layer/python
RUN pip install psycopg2-binary requests langfuse -t /layer/python

# Package the layer
WORKDIR /layer
RUN zip -r9 /opt/lambda-layer.zip .

# Copy zip to output
CMD ["cp", "/opt/lambda-layer.zip", "/out/lambda-layer.zip"]
