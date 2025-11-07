#!/bin/bash

# Variables
KEY_PATH=~/.ssh/mara_cloud_deployment.pem
EC2_HOST=ec2-user@18.171.234.207
REMOTE_DIR=/home/ec2-user/message-server

# Copy necessary files
echo "> Uploading files to EC2"
scp -i $KEY_PATH app.py requirements.txt Dockerfile $EC2_HOST:$REMOTE_DIR

# Connect and run container
ssh -i $KEY_PATH $EC2_HOST << EOF
  cd message-server
  docker build -t message-server .
  docker stop message-server || true
  docker rm message-server || true
  docker run -p 5002:5002 \
    -e APP_ENV=PRODUCTION \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=H0pk1ns0n15! \
    -e POSTGRES_HOST=mara-message-server-db.cvruukypsgyb.eu-west-2.rds.amazonaws.com \
    -e POSTGRES_DB=postgres \
    message-server
EOF

echo "✅ Deployment complete! Visit: http://18.171.234.207:5002"
