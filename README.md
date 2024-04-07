# Automating Mediawiki Deployment
This project aims to automate the deployment of Mediawiki on a Google Cloud Platform (GCP) server. We leverage the power of Terraform for infrastructure provisioning and Bash scripting for LAMP stack configuration.

## Overview
Our approach involves using Terraform as an Infrastructure as Code (IaC) tool to provision a Linux Virtual Machine (VM) on GCP, specifically with a CentOS image. The process of installing Mediawiki on the server is automated using a Bash script, which is integrated within our Terraform code as a remote provisioner.

To ensure efficient management and version control of our Terraform deployments, we utilize Terraform Cloud. Our workspace is configured with Version Control System (VCS) integration, specifically with a GitHub webhook. This setup allows for seamless updates and tracking of our infrastructure setup.

In this project, we utilize a variety of tools and technologies, which also serve as prerequisites, essential for executing the automation process:

- GIT: Used for version control and source code management.
- Terraform Cloud: Provides a consistent workflow for managing and versioning our Terraform infrastructure.
- Google Cloud Platform (GCP): Our chosen cloud provider where the server is provisioned.
- Bash: Used to automate the server configuration process, specifically for setting up the LAMP stack.

By automating the deployment process, we aim to minimize manual intervention, reduce errors, and ensure a consistent and reliable setup of Mediawiki.

## Installation and Running the Automation
1. Terraform
