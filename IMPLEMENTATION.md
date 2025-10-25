
# 🏗️ AWS 3-Tier Web Application Implementation Guide 

This guide covers **all steps** to implement your **AWS 3-Tier Web Application using Terraform and Ansible**.

---

## **Step 0: Prerequisites**

1. Install required tools:
   - Terraform >= 1.1
   - AWS CLI v2
   - Ansible >= 2.9
   - Git
2. AWS account setup:
   - Create IAM user with necessary permissions (EC2, VPC, RDS, S3, ALB, IAM, SNS, CloudWatch)
   - Configure AWS CLI:
     ```bash
     aws configure
     ```
3. Local project setup:
   ```bash
   mkdir -p ~/projects/aws_3Tier_webapp_Terraform
   cd ~/projects/aws_3Tier_webapp_Terraform
   ```
4. Decide S3 backend & DynamoDB for Terraform state:
   - Bucket example: `shubham-terraform-backend`
   - DynamoDB example: `terraform-locks`

---

## **Step 1: Configure Backend & Variables**

1. Update `backend.tf`:
```hcl
bucket = "shubham-terraform-backend"
region = "ap-south-1"
dynamodb_table = "terraform-locks"
```

2. Update `terraform.tfvars` with your details:
```hcl
allowed_ssh_cidr = "YOUR_PUBLIC_IP/32"
db_password = "SuperStrongPassword123!"
```

3. Optional: Change `key_name` in `variables.tf` if you want a custom SSH key.

---

## **Step 2: Initialize Terraform**

```bash
terraform init
```

- Initializes modules, providers, and backend.

---

## **Step 3: Review Terraform Plan**

```bash
terraform plan -out plan.tfplan
```

- Verify that Terraform will create:
  - VPC, Subnets, IGW, NAT Gateway, Route Tables
  - Security Groups
  - RDS MySQL
  - EC2 Launch Template + Auto Scaling Group
  - Application Load Balancer

---

## **Step 4: Apply Terraform**

```bash
terraform apply -auto-approve
```

- Resources created:
  - VPC + Public/Private/DB Subnets
  - NAT Gateway, IGW, Route Tables
  - Security Groups
  - RDS MySQL instance
  - EC2 Auto Scaling Group
  - Application Load Balancer
  - SSH key pair

- Outputs:
  - `alb_dns_name` → for browser access
  - `db_endpoint` → for database connection
  - `private_key_path` → path to SSH key

---

## **Step 5: Configure Web Servers Using Ansible**

1. Update `ansible/inventory` with EC2 private IPs:
```ini
[webservers]
10.0.101.12 ansible_user=ec2-user ansible_ssh_private_key_file=../shubham-key.pem
```

2. Run playbook:
```bash
cd ansible
ansible-playbook -i inventory webapp.yml
```

- Installs `httpd` and deploys sample web page.

---

## **Step 6: Test the Application**

- Open ALB DNS in browser: `http://<alb_dns_name>`
- Verify:
  - Web page loads correctly
  - EC2 instances are balanced via ALB
  - Database connectivity (optional):
    ```bash
    mysql -h <db_endpoint> -u <db_user> -p
    ```

- Optional: Configure CloudWatch + SNS alerts.

---

## **Step 7: Modify or Scale Infrastructure**

- Change Auto Scaling Group size in `variables.tf`:
```hcl
asg_min_size = 2
asg_max_size = 4
```
- Apply changes:
```bash
terraform apply -auto-approve
```
- Update `user_data.sh.tpl` or Ansible playbook for custom apps.

---

## **Step 8: Destroy Infrastructure (Cleanup)**

```bash
terraform destroy -auto-approve
```

- Removes all AWS resources.
- Important: Ensure `skip_final_snapshot = true` if you want to delete RDS backups.

---

## **Optional Enhancements**

1. Enable HTTPS with ACM certificate.
2. Use AWS Secrets Manager for DB passwords.
3. Dynamic inventory in Ansible.
4. CloudWatch alarms and SNS notifications.

---

## **Commands Cheat Sheet**

```bash
# Terraform
terraform init
terraform plan -out plan.tfplan
terraform apply -auto-approve
terraform destroy -auto-approve

# Ansible
cd ansible
ansible-playbook -i inventory webapp.yml
```

---

✅ **Outcome:**
- Fully automated 3-tier AWS architecture
- ALB load balances EC2 instances
- RDS hosts the application backend
- Infrastructure as Code with Terraform
- Configuration management with Ansible
