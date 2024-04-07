# Automating Mediawiki Deployment
This project aims to automate the deployment of Mediawiki on a Google Cloud Platform (GCP) server. We leverage the power of Terraform for infrastructure provisioning and Bash scripting for LAMP stack configuration.

## Overview
Our approach involves using Terraform as an Infrastructure as Code (IaC) tool to provision a Linux Virtual Machine (VM) on GCP, specifically with a CentOS image. The process of installing Mediawiki on the server is automated using a Bash script, which is integrated within our Terraform code as a remote provisioner.

To ensure efficient management and version control of our Terraform deployments, we utilize Terraform Cloud. Our workspace is configured with Version Control System (VCS) integration, specifically with a GitHub webhook. This setup allows for seamless updates and tracking of our infrastructure setup.

In this project, we utilize a variety of tools and technologies, which also serve as prerequisites, essential for executing the automation process:

- **GIT:** Used for version control and source code management.
- **Terraform Cloud:** Provides a consistent workflow for managing and versioning our Terraform infrastructure.
- **Google Cloud Platform (GCP):** Our chosen cloud provider where the server is provisioned.
- **Bash:** Used to automate the server configuration process, specifically for setting up the LAMP stack.

By automating the deployment process, we aim to minimize manual intervention, reduce errors, and ensure a consistent and reliable setup of Mediawiki.

## Installation and Running the Automation
1. The first step involves setting up your project and workspace in Terraform Cloud. This is a crucial step as it lays the groundwork for your infrastructure deployment. You can follow the instructions provided in this Terraform Cloud Projects Tutorial.
   https://developer.hashicorp.com/terraform/tutorials/cloud/projects
   
2. Once the project and wokspace is setup we need to link workspace with our github repo. For this project we have use VCS driven workflow but as per the requirement API driven and CLI driven workflow can also be used. Below link can be followed for setup.
  https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-vcs-change
  
3. Once the workspace is ready and linked with your repository, you are all set for the infrastructure deployment. With every commit made to the repo, Terraform will automatically execute a plan and apply in the cloud workspace. This ensures that your infrastructure stays up-to-date with your latest configurations

4. In addition to automating infrastructure deployment, we are also leveraging Terraform Cloud for efficient management of our variables and state files. This approach ensures a centralized, secure, and version-controlled storage for our Terraform state files, while also providing a convenient way to manage and update our variables. Please refer to the screenshots below for a visual reference of our setup.
   
   ![image](https://github.com/rujhaan123/Th-Assignment/assets/33410430/dba89942-d72a-4e82-91d4-e19252346849)

   ![image](https://github.com/rujhaan123/Th-Assignment/assets/33410430/bdb038ac-6270-4197-9eda-250559acf084)

   ![image](https://github.com/rujhaan123/Th-Assignment/assets/33410430/4dc8312a-c870-407a-befa-49aaaf4c8b64)

   ![image](https://github.com/rujhaan123/Th-Assignment/assets/33410430/4c94614e-de7e-4e91-b5cf-c8b811d2a0b1)

   ![image](https://github.com/rujhaan123/Th-Assignment/assets/33410430/69785a9b-c350-41b2-8c06-7c32099849df)
   

   ![image](https://github.com/rujhaan123/Th-Assignment/assets/33410430/7dd1005e-265e-47d6-8c71-244c79874e12)

### Note
- We have chosen to use Terraform Cloud for managing our state file and orchestrating our cloud deployment. This choice is particularly advantageous when working in a team environment as it provides a centralized, version-controlled, and secure location for state files. However, it’s worth noting that these tasks can also be performed directly from a local machine.
- Our automation process is designed to trigger whenever a commit is made to the GitHub repository. This setup ensures that our infrastructure stays up-to-date with the latest configurations. Additionally, for those interested in setting up a continuous integration/continuous deployment (CI/CD) process for managing builds and deployments, an API-driven workflow can also be implemented.
- We have utilized a Bash script to automate the installation of Mediawiki on our Linux VM. For scaling this setup across multiple VMs, other configuration management tools such as Ansible can be employed.
- The same application configuration can also be deployed on a Kubernetes cluster if required. Instead of provisioning a VM, we can deploy a Kubernetes cluster using Terraform and run Mediawiki using a container image.









