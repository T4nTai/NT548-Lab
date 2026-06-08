# Lab01 - Terraform AWS Infrastructure

Triển khai hạ tầng AWS gồm VPC, public/private subnet, Security Group và 2 EC2 instance bằng Terraform.

## Kiến trúc

- **VPC** (`10.0.0.0/16`) với Internet Gateway và NAT Gateway
- **Public Subnet** (`10.0.1.0/24`) — EC2 có Public IP, cho phép SSH từ ngoài
- **Private Subnet** (`10.0.2.0/24`) — EC2 không có Public IP, ra internet qua NAT

## Yêu cầu

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI đã cấu hình (`aws configure`)
- Một EC2 Key Pair đã tạo sẵn trên AWS

## Cách chạy

### 1. Chuẩn bị biến đầu vào

Tạo file `terraform.tfvars` trong thư mục `Lab01/`:

```hcl
key_name        = "ten-key-pair-cua-ban"
allowed_ssh_cidr = "your_ip/32"   # IP của bạn, ví dụ: 203.0.113.10/32
```

Các biến còn lại đã có giá trị mặc định. Có thể ghi đè nếu cần:

```hcl
aws_region          = "us-east-1"
availability_zone   = "us-east-1a"
instance_type       = "t2.micro"
ami_id              = "ami-0c02fb55956c7d316"   # Amazon Linux 2, us-east-1
```

### 2. Khởi tạo Terraform

```bash
cd Lab01
terraform init
```

### 3. Xem trước các thay đổi

```bash
terraform plan
```

### 4. Triển khai hạ tầng

```bash
terraform apply
```

Nhập `yes` khi được hỏi xác nhận.

### 5. Kiểm tra kết quả

Sau khi apply xong, Terraform in ra các output:

```
vpc_id                = "vpc-xxxxxxxx"
public_subnet_id      = "subnet-xxxxxxxx"
private_subnet_id     = "subnet-yyyyyyyy"
public_instance_id    = "i-xxxxxxxxxxxxxxxxx"
private_instance_id   = "i-yyyyyyyyyyyyyyyyy"
```

SSH vào public instance:

```bash
ssh -i /path/to/your-key.pem ec2-user@<public_ip>
```

### 6. Xóa hạ tầng

```bash
terraform destroy
```

## Cấu trúc thư mục

```
Lab01/
├── main.tf               # Root module, gọi các module con
├── variables.tf          # Khai báo biến
├── outputs.tf            # Output sau khi apply
├── terraform.tfvars      # Giá trị biến (tự tạo, không commit)
└── modules/
    ├── vpc/              # VPC, Subnet, IGW, NAT Gateway, Route Table
    ├── security/         # Security Group cho public và private EC2
    └── ec2/              # EC2 Instance
```
