
# Terraform AWS VPC with Public and Private EC2 + NAT Gateway

## 🧾 Overview

This project provisions a **production-grade AWS VPC** using Terraform.  
It includes both **public and private subnets**, **EC2 instances**, and a **NAT Gateway** to enable internet access from private resources.  
The infrastructure is ideal for real-world workloads where security and isolation are essential.

---

## 🛠️ Tools & Services Used

- Terraform
- AWS VPC, Subnets (public/private)
- AWS EC2 (Amazon Linux 2)
- AWS Internet Gateway, NAT Gateway, Route Tables
- AWS Security Groups
- AWS Key Pair (SSH)
- Remote Backend (S3 + DynamoDB) – Optional

---

## 🧱 Architecture

- **VPC CIDR**: `10.0.0.0/16`
- **Public Subnets**: `10.0.1.0/24`, `10.0.3.0/24`
- **Private Subnets**: `10.0.2.0/24`, `10.0.4.0/24`
- **NAT Gateway**: Attached to Public Subnet for Private EC2 outbound internet
- **EC2 Instances**:
  - Public EC2 (SSH + Web access)
  - Private EC2 (no public IP, internet via NAT)

---

## 🔐 Security Groups

- **Public EC2 SG**: Allows SSH (port 22) from anywhere (`0.0.0.0/0`)
- **Private EC2 SG**: Allows SSH only from Public EC2 (via SG reference)

---

## 🔧 Terraform Files

| File | Purpose |
|------|---------|
| `main.tf` | VPC, subnets, route tables, IGW, NAT Gateway |
| `ec2.tf` | EC2 instances, key pair, security groups |
| `variables.tf` | Input variables |
| `outputs.tf` | Useful outputs like public/private IPs |
| `backend.tf` | (Optional) Remote state config with S3 + DynamoDB |

---

## 🚀 How to Use

### 1. Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform installed (`terraform -version`)
- SSH key pair created locally:
  ```bash
  ssh-keygen -t rsa -f terraform-key-day7
  ```

---

### 2. Clone the Repository

```bash
git clone https://github.com/AnnuRLohan/terraform-vpc-prod-ec2.git
cd terraform-vpc-prod-ec2
```

---

### 3. Initialize Terraform

```bash
terraform init
```

---

### 4. Review the Execution Plan

```bash
terraform plan
```

---

### 5. Apply the Configuration

```bash
terraform apply
```

---

### 6. SSH into EC2 Instances

#### Public EC2:
```bash
ssh -i terraform-key-day7 ec2-user@<PUBLIC_EC2_PUBLIC_IP>
```

#### Private EC2 (via Public EC2):
```bash
# From your local
scp -i terraform-key-day7 terraform-key-day7 ec2-user@<PUBLIC_EC2_PUBLIC_IP>:~/

# On public EC2
chmod 400 terraform-key-day7
ssh -i terraform-key-day7 ec2-user@<PRIVATE_EC2_PRIVATE_IP>
```

---

## 🧪 What to Test

- SSH into public EC2 ✅  
- From public EC2, SSH into private EC2 ✅  
- On private EC2, run:
  ```bash
  curl https://ifconfig.me
  ```
  → Confirms outbound internet via NAT Gateway

---

## 🧹 Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

> ⚠️ This does **not delete** the S3/DynamoDB backend if used

---

## 📁 Project Structure

```
terraform-vpc-prod-ec2/
├── main.tf
├── ec2.tf
├── variables.tf
├── outputs.tf
├── backend.tf (optional)
├── terraform-key-day7 (excluded via .gitignore)
├── terraform-key-day7.pub
├── .gitignore
└── README.md
```

---

## 📌 Notes

- This is a **secure, realistic baseline** for most AWS projects
- NAT Gateway ensures **private EC2 can access the internet** without being publicly exposed
- SSH keys and `.terraform/` folders are **excluded from GitHub** via `.gitignore`

---

## 👨‍💻 Author

**Annu Lohan**  
DevOps Enthusiast | Practical Learner | Automation Lover  
🔗 [LinkedIn](https://www.linkedin.com/in/annulohan) | 💼 More Projects Coming Soon!
