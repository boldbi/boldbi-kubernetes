<a href="https://www.boldbi.com">
  <img
  src="https://www.boldbi.com/wp-content/uploads/2019/05/boldbi-header-menu-logo.svg"
  alt="boldbi"
  width="400"/>
</a>
<br/><br/>

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/boldbi/boldbi-kubernetes?sort=semver)](https://github.com/boldbi/boldbi-kubernetes/releases/latest)
[![Documentation](https://img.shields.io/badge/docs-help.boldbi.com-blue.svg)](https://help.boldbi.com/embedded-bi)
[![File Issues](https://img.shields.io/badge/file_issues-boldbi_support-blue.svg)](https://www.boldbi.com/support)

# What is Bold BI

Bold BI is a powerful business intelligence dashboard software that helps you to get meaningful insights from your business data and make better decisions.

It is an end-to-end solution for creating, managing, and sharing interactive business dashboards that include a powerful dashboard designer for composing easily.

With deep embedding, you can interact more with your data and get insights directly from your application.

# Bold BI on Kubernetes

## Prerequisites

The following requirements are necessary to run the Bold BI solution.

* Kubernetes cluster
* File storage
* Microsoft SQL Server 2012+ | PostgreSQL
* Load balancer: [Nginx](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/) or [Istio](https://istio.io/latest/docs/setup/getting-started/)
* Web Browser: Microsoft Edge, Mozilla Firefox, and Chrome.

### Deployment Methods

There are two ways to deploy Bold BI on the Kubernetes cluster. Please refer to the following documents for Bold BI deployment:

* [Deploy Bold BI using kubectl](docs/index.md)
* Helm Deployment</br>
    1. [Deploy Bold BI using Helm](helm/README.md)
    2. [Common deployment using Helm](helm/bold-common/README.md)

# License

https://www.boldbi.com/terms-of-use/embedded<br />

The images are provided for your convenience and may contain other software that is licensed differently (Linux system, Bash, etc. from the base distribution, along with any direct or indirect dependencies of the Bold BI platform).

These pre-built images are provided for convenience and include all optional and additional libraries by default. These libraries may be subject to different licenses than the Bold BI product.

If you want to install Bold BI from scratch and precisely control which optional libraries are installed, please download the stand-alone product from boldbi.com. If you have any questions, please contact the Bold BI team (https://www.boldbi.com/support).

It is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
