# Lab02 - DevOps: Terraform, CloudFormation, Jenkins, SonarQube

## Giới thiệu
Lab02 triển khai hạ tầng AWS và CI/CD pipeline sử dụng Terraform, CloudFormation, GitHub Actions, AWS CodePipeline và Jenkins.

---

## Cấu trúc thư mục
Lab02/
├── part1-terraform/          # Phần 1: Terraform + GitHub Actions + Checkov
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ec2/
│   │   └── security/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── part2-cloudformation/     # Phần 2: CloudFormation + CodePipeline
│   ├── templates/
│   │   ├── vpc.yaml
│   │   ├── security.yaml
│   │   └── ec2.yaml
│   └── buildspec.yml
└── part3-jenkins/            # Phần 3: Jenkins + SonarQube
├── Jenkinsfile
└── sonar-project.properties

---

## Phần 1: Terraform + GitHub Actions + Checkov

### Yêu cầu
- Terraform >= 1.7.0
- AWS CLI đã cấu hình credentials
- Python 3.11+ (cho Checkov)

### Cài đặt môi trường
```bash
# Cài Checkov
pip install checkov

# Cài Terraform (Windows)
choco install terraform
```

### Chạy Terraform
```bash
cd Lab02/part1-terraform
terraform init
terraform plan
terraform apply
```

### Chạy Checkov thủ công
```bash
checkov -d Lab02/part1-terraform --framework terraform --output cli
```

### GitHub Actions
Pipeline tự động trigger khi push code vào nhánh `main` trong thư mục `Lab02/part1-terraform/**`:
- **Checkov Security Scan**: kiểm tra bảo mật Terraform code
- **Terraform Validate**: kiểm tra format và validate code

### Cấu hình GitHub Secrets
| Secret | Mô tả |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key |

---

## Phần 2: CloudFormation + CodePipeline + CodeBuild

### Yêu cầu
- AWS CLI đã cấu hình
- Tài khoản AWS với quyền CloudFormation, CodePipeline, CodeBuild

### Templates CloudFormation
| Template | Mô tả |
|----------|-------|
| `templates/vpc.yaml` | VPC, Subnet, IGW, NAT Gateway, Route Tables |
| `templates/security.yaml` | Security Groups cho Public và Private EC2 |
| `templates/ec2.yaml` | EC2 instances Public và Private |

### Deploy thủ công
```bash
# Deploy VPC stack
aws cloudformation deploy \
  --template-file Lab02/part2-cloudformation/templates/vpc.yaml \
  --stack-name lab02-vpc-stack \
  --region us-east-1

# Deploy Security stack
aws cloudformation deploy \
  --template-file Lab02/part2-cloudformation/templates/security.yaml \
  --stack-name lab02-security-stack \
  --region us-east-1

# Deploy EC2 stack
aws cloudformation deploy \
  --template-file Lab02/part2-cloudformation/templates/ec2.yaml \
  --stack-name lab02-ec2-stack \
  --parameter-overrides KeyName=lab02-keypair \
  --region us-east-1
```

### Kiểm tra cfn-lint
```bash
pip install cfn-lint
cfn-lint Lab02/part2-cloudformation/templates/vpc.yaml
cfn-lint Lab02/part2-cloudformation/templates/security.yaml
cfn-lint Lab02/part2-cloudformation/templates/ec2.yaml
```

### AWS CodePipeline
Pipeline `lab02-cloudformation-pipeline` tự động trigger từ GitHub:
1. **Source**: Lấy code từ GitHub repo
2. **Build**: CodeBuild chạy cfn-lint validate templates

---

## Phần 3: Jenkins + SonarQube

### Yêu cầu
- Docker đã cài đặt
- EC2 instance t3.medium (RAM >= 4GB)

### Cài đặt Jenkins và SonarQube
```bash
# Cài Docker
sudo apt install -y docker.io
sudo systemctl start docker

# Chạy Jenkins
sudo docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Lấy password admin Jenkins
sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Chạy SonarQube
sudo docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:community
```

### Truy cập
| Service | URL | Credentials |
|---------|-----|-------------|
| Jenkins | http://\<EC2-IP\>:8080 | admin / \<password\> |
| SonarQube | http://\<EC2-IP\>:9000 | admin / \<password\> |

### Cấu hình Jenkins
1. Cài plugin **SonarQube Scanner**
2. **Manage Jenkins → Tools**: thêm SonarQube Scanner tên `sonar-scanner`
3. **Manage Jenkins → System**: thêm SonarQube server URL và token

### Cấu hình SonarQube Webhook
**Administration → Webhooks → Create**:
- URL: `http://<EC2-IP>:8080/sonarqube-webhook/`

### Chạy Pipeline
1. Tạo Jenkins Pipeline job
2. Source: GitHub repo `T4nTai/NT548-Lab`
3. Script Path: `Lab02/part3-jenkins/Jenkinsfile`
4. Click **Build Now**

### Kết quả kiểm tra
Pipeline thực hiện các bước:
1. **Checkout**: lấy code từ GitHub
2. **SonarQube Analysis**: phân tích chất lượng code
3. **Quality Gate**: kiểm tra kết quả SonarQube
4. **Build**: hoàn thành pipeline