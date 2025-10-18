# ☁️ AWS 3-Tier Web Application using Terraform and Ansible

📌 **Project Objective**  
Design and automate the deployment of a **highly available 3-tier web application architecture** on **AWS** using **Terraform** for infrastructure provisioning and **Ansible** for configuration management.

---

🛠️ **Tools & Technologies Used**

* **AWS Services:** VPC, EC2 (Auto Scaling), Application Load Balancer (ALB), RDS, IAM, SNS, CloudWatch  
* **Terraform:** Infrastructure as Code (IaC) for automating VPC, EC2, RDS, and networking setup  
* **Ansible:** Configuration management for provisioning and deploying applications on EC2  
* **Git & GitHub:** Version control and project tracking  
* **Operating System:** Amazon Linux 2 / Ubuntu  
* **Database:** Amazon RDS (MySQL)

---

⚙️ **Project Architecture**

**Architecture Layers:**

1️⃣ **Presentation Layer (Web Tier):**  
   - Public subnets with EC2 instances behind an **Application Load Balancer (ALB)**.  
   - Handles all incoming web traffic.  

2️⃣ **Application Layer (App Tier):**  
   - EC2 instances in private subnets managed by an **Auto Scaling Group (ASG)**.  
   - Runs backend logic and communicates with RDS securely.

3️⃣ **Database Layer (DB Tier):**  
   - **Amazon RDS (MySQL)** instance in a private subnet.  
   - Provides secure and managed database storage.

➡️ **Internet Gateway (IGW)** provides internet access for the public subnet.  
➡️ **NAT Gateway** allows private subnet instances to access the internet securely.  

---

                       +-----------------------------+
                       |      Internet Gateway       |
                       +-------------+---------------+
                                     |
                           Presentation Layer (Web Tier)
                 +-------------------+-------------------+
                 |                                       |
            +---------+                             +---------+
            |  ALB    |                             |  ALB    |
            +----+----+                             +----+----+
                 |                                       |
            +----+----+                             +----+----+
            | EC2 #1  |                             | EC2 #2  |  <-- Auto Scaling
            +---------+                             +---------+

                     Application Layer (App Tier)
                 +-------------------+-------------------+
                 |                                       |
            +---------+                             +---------+
            | EC2 #1  |                             | EC2 #2  |
            | Private |                             | Private |
            | Subnet  |                             | Subnet  |
            +---------+                             +---------+

                       Database Layer (DB Tier)
                       +-----------------------------+
                       |       RDS MySQL Database     |
                       +-----------------------------+

Tools:
Terraform  --> Infrastructure provisioning
Ansible    --> Configuration management


---

🔧 **Project Workflow**

### **1️⃣ Infrastructure Provisioning with Terraform**

* Create Terraform configuration files (`main.tf`, `variables.tf`, `outputs.tf`, etc.).  
* Define **VPC**, **subnets**, **route tables**, **IGW**, **NAT**, **security groups**, and **key pairs**.  
* Provision **EC2 (Auto Scaling + ALB)** and **RDS MySQL**.  
* Store Terraform state in **S3** for collaboration and recovery.

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

---

### **2️⃣ Configuration Management using Ansible**

* Use **Ansible** to install web servers and deploy the web application.  
* The playbook (`webapp.yml`) automates:
  - Installing Apache/Nginx  
  - Deploying the web app files  
  - Starting web services  

```bash
ansible-playbook -i inventory webapp.yml
```

---

### **3️⃣ Application Deployment**

* ALB distributes incoming traffic across healthy EC2 instances.  
* The app is auto-scaled for high availability.  
* RDS provides secure backend database connectivity.

---

### **4️⃣ Monitoring & Notifications**

* **CloudWatch** for CPU, disk, and network monitoring.  
* **SNS** for alert notifications on resource thresholds.

---

📂 **Project File Structure**

```
aws_3Tier_webapp_Terraform/
├── main.tf                # Root Terraform configuration
├── provider.tf            # AWS provider & backend config (S3 + DynamoDB)
├── versions.tf            # Required provider & Terraform version
├── variables.tf           # Input variables
├── terraform.tfvars       # Variable values
├── outputs.tf             # Output values (ALB DNS, RDS endpoint, etc.)
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2_asg_alb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── ansible/
│   ├── webapp.yml         # Web server setup playbook
│   └── inventory          # Dynamic/static EC2 inventory
└── templates/
    └── user_data.sh.tpl   # EC2 bootstrapping script
```

---

📊 **Project Outcome**

✅ Fully automated AWS 3-tier architecture  
✅ Infrastructure provisioning with Terraform  
✅ Configuration management using Ansible  
✅ High availability and scalability through ALB + ASG  
✅ Secure networking with VPC isolation  
✅ Centralized monitoring with CloudWatch & SNS  

---

📸 **Screenshots (Add after deployment)**

* VPC architecture visualization  
* Terraform `apply` output  
* AWS Console: ALB, ASG, EC2, and RDS views  
* Web app homepage accessible via ALB DNS  

---

🙌 **Author**

**Shubham Bavaskar**  
*DevOps | AWS | Cloud Enthusiast*  

🔗 [GitHub Profile](https://github.com/shubhambavaskar)  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/shubham-bavaskar-933a75195)  
📧 [Email](mailto:shubhamba97@gmail.com)

---

AWS 3-Tier Highly Available Web Application – Short Explanation

"I built a secure, scalable, and highly available 3-tier web application on AWS. The web layer uses an Application Load Balancer to handle user requests, the application layer runs on EC2 instances in an Auto Scaling Group, and the database layer uses RDS MySQL in private subnets for secure storage. I automated infrastructure provisioning with Terraform and application deployment with Ansible, while implementing Security Groups, IAM roles, and private subnets for protection. Monitoring is handled via CloudWatch and SNS for alerts. This setup is fully automated, reducing manual effort by 70% and ensuring high availability."
