# Deployment Checklist

## Pre-Deployment

### AWS Account Setup

- [ ] Create AWS account
- [ ] Verify email
- [ ] Add payment method
- [ ] Enable free tier

### IAM User Setup

- [ ] Create IAM user for Terraform
- [ ] Attach policies:
  - [ ] AmazonS3FullAccess
  - [ ] AmazonEC2FullAccess
  - [ ] CloudFrontFullAccess
  - [ ] IAMFullAccess
- [ ] Create access keys
- [ ] Save Access Key ID
- [ ] Save Secret Access Key

### EC2 Key Pair

- [ ] Create EC2 key pair in AWS
- [ ] Download .pem file
- [ ] Save to safe location
- [ ] Set permissions: `chmod 400 key.pem`

### Local Setup

- [ ] Install Terraform: `brew install terraform`
- [ ] Install AWS CLI: `brew install awscli`
- [ ] Configure AWS: `aws configure`
- [ ] Verify AWS credentials: `aws sts get-caller-identity`

## Terraform State Backend

### S3 Bucket for State

- [ ] Create S3 bucket: `my-demo-app-terraform-state-dev`
- [ ] Enable versioning
- [ ] Enable encryption
- [ ] Block public access

### DynamoDB Table for Locking

- [ ] Create DynamoDB table: `terraform-locks-dev`
- [ ] Set primary key: `LockID`
- [ ] Set provisioned throughput: 5 RCU, 5 WCU

## Configuration

### Update terraform.tfvars

Edit `terraform/dev/terraform.tfvars`:

- [ ] `key_pair_name` = Your EC2 key pair name
- [ ] `allowed_ssh_cidr` = Your IP address (e.g., "203.0.113.0/32")
- [ ] `github_repo` = Your GitHub repository URL
- [ ] `branch` = "main" (or your branch)

### Verify Variables

```bash
cd terraform/dev
terraform validate
```

- [ ] No validation errors

## Deployment

### Initialize Terraform

```bash
cd terraform/dev
terraform init
```

- [ ] Initialization successful
- [ ] Backend configured
- [ ] Modules downloaded

### Plan Deployment

```bash
terraform plan -out=tfplan
```

- [ ] Review plan output
- [ ] Verify resources to be created:
  - [ ] S3 bucket
  - [ ] CloudFront distribution
  - [ ] EC2 instance
  - [ ] Security group
  - [ ] IAM role
  - [ ] Elastic IP

### Apply Configuration

```bash
terraform apply tfplan
```

- [ ] Deployment successful
- [ ] No errors
- [ ] Resources created

### Get Outputs

```bash
terraform output
```

- [ ] Note frontend URL
- [ ] Note backend URL
- [ ] Note backend IP
- [ ] Note S3 bucket name
- [ ] Note CloudFront distribution ID
- [ ] Note EC2 instance ID

## Post-Deployment Verification

### Frontend

- [ ] Open CloudFront URL in browser
- [ ] Verify page loads
- [ ] Check browser console for errors

### Backend

- [ ] Test health endpoint:
  ```bash
  curl http://BACKEND_IP:5050/health
  ```
- [ ] Verify response: `{"status":"OK","message":"Server is running"}`

### Application

- [ ] Test login with admin/1234
- [ ] Verify welcome page appears
- [ ] Test logout
- [ ] Verify redirect to login

### Security

- [ ] Verify SSH
      itoring

### CloudWatch Logs

- [ ] Check EC2 system logs
- [ ] Check application logs
- [ ] Check Nginx logs

### AWS Console

- [ ] Verify S3 bucket has files
- [ ] Verify CloudFront distribution is active
- [ ] Verify EC2 instance is running
- [ ] Verify security groups are correct

## Documentation

### Update Documentation

- [ ] Update DEPLOYMENT.md with your URLs
- [ ] Update INFRASTRUCTURE_SETUP.md with your setup
- [ ] Document any custom configurations
- [ ] Document access procedures

### Backup

- [ ] Backup terraform.tfstate
- [ ] Backup .pem file
- [ ] Backup AWS credentials
- [ ] Store in secure location

## Scaling to PROD (Future)

When ready to add PROD:

- [ ] Copy `terraform/dev/` to `terraform/prod/`
- [ ] Update `terraform/prod/backend.tf` with prod bucket names
- [ ] Update `terraform/prod/terraform.tfvars` with prod values
- [ ] Run `terraform init` in prod directory
- [ ] Run `terraform plan` to review
- [ ] Run `terraform apply` to deploy

## Maintenance

### Regular Tasks

- [ ] Monitor costs in AWS console
- [ ] Review security groups monthly
- [ ] Update SSH access CIDR as needed
- [ ] Backup state files regularly
- [ ] Review logs for errors

### Updates

- [ ] Update Terraform version when available
- [ ] Update AWS provider version
- [ ] Update Node.js version
- [ ] Update dependencies

## Troubleshooting

### If Deployment Fails

1. **Check Terraform logs**

   ```bash
   TF_LOG=DEBUG terraform apply
   ```

2. **Validate configuration**

   ```bash
   terraform validate
   ```

3. **Check AWS console**
   - Verify IAM permissions
   - Verify resource limits
   - Check service quotas

4. **Check EC2 logs**

   ```bash
   aws ec2 get-console-output --instance-id i-xxxxx
   ```

5. **SSH into EC2**
   ```bash
   ssh -i key.pem ubuntu@BACKEND_IP
   pm2 logs backend
   ```

### If Application Doesn't Work

1. **Check backend**

   ```bash
   curl http://BACKEND_IP:5050/health
   ```

2. **Check frontend**
   - Open browser console
   - Check for API errors
   - Verify backend URL in code

3. **Check security groups**
   - Verify ports are open
   - Verify CORS is configured
   - Verify firewall rules

## Success Criteria

✅ **Deployment Complete When:**

- [ ] Terraform apply succeeds
- [ ] All resources created in AWS
- [ ] Frontend loads in browser
- [ ] Backend health check responds
- [ ] Login works with admin/1234
- [ ] Welcome page displays
- [ ] Logout works
- [ ] GitHub Actions workflow passes
- [ ] No errors in logs
- [ ] All documentation updated

## Next Steps

After successful deployment:

1. **Test thoroughly**
   - [ ] Test all features
   - [ ] Test error cases
   - [ ] Test edge cases

2. **Monitor**
   - [ ] Watch logs
   - [ ] Monitor costs
   - [ ] Check performance

3. **Optimize**
   - [ ] Optimize performance
   - [ ] Reduce costs
   - [ ] Improve security

4. **Scale**
   - [ ] Create PROD environment
   - [ ] Add monitoring
   - [ ] Add custom domain
   - [ ] Add SSL certificate

## Support

If you encounter issues:

1. Check Terraform documentation
2. Check AWS documentation
3. Review GitHub Actions logs
4. Check EC2 system logs
5. Review application logs

## Completion

- [ ] All checklist items completed
- [ ] Application deployed successfully
- [ ] Documentation updated
- [ ] Team notified
- [ ] Ready for production use

**Deployment Date:** **\*\***\_\_\_**\*\***
**Deployed By:** **\*\***\_\_\_**\*\***
**Notes:** **\*\***\_\_\_**\*\***
