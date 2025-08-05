# Kubernetes Compatibility for Bold BI

This document provides detailed information on the Kubernetes versions, ingress controllers, storage options, and environments tested for compatibility with Bold BI deployments. For production use, we recommend adhering to the validated configurations listed below.

## Compatibility Overview

Bold BI is tested on specific Kubernetes versions and environments to ensure stability and performance. The following table outlines the supported configurations, including Kubernetes versions, ingress controllers, storage options, and tested environments.

| Bold BI Version | Kubernetes Supported Versions | Ingress-Nginx Tested Versions | Tested Environments | Date of Release | Notes |
|-----------------|-------------------------------|-------------------------------|---------------------|-----------------|-------|
| 12.1.5          | 1.31.x, 1.32.x                | 4.11.3                        | AKSUbuntu-2204gen2containerd-202507.21.0 | 2025-06-04 | Recommended for production. Supports Helm and Kubectl deployments. |

### Notes

- **Tested Environments**: The listed environments include major managed Kubernetes providers (AKS, EKS, GKE, OKE, ACK) and specific versions where compatibility was verified.
- **Ingress Controllers**: While `ingress-nginx` is tested, also provided support for other controllers like Istio.

## Recommendations

- Always use the latest Bold BI version (e.g., 12.1.5 as of June 2025) for optimal compatibility and security.
- Regularly update your ingress-nginx controller to the latest tested version to avoid security vulnerabilities.

## How to Stay Updated

- Monitor the [Bold BI GitHub repository](https://github.com/boldbi/boldbi-kubernetes) for release notes and compatibility updates.
- Contact the [Bold BI Support Team](https://www.boldbi.com/support) for assistance with specific configurations or issues.

For additional deployment instructions, return to the [main README](../README.md).
