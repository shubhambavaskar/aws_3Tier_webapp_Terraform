#!/bin/bash
yum update -y
yum install -y httpd mysql
systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Terraform 3-Tier App</title></head>
  <body>
    <h1>Welcome to ${project_name} (Auto-provisioned)</h1>
    <p>App server connected to DB endpoint: ${db_endpoint}</p>
  </body>
</html>
EOF
