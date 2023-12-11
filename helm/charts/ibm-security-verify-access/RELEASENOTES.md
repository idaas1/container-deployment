# What's new in verify-access v1.3.1 Chart
The following enhancements have been made:
* Update default version to 10.0.3.1

# Documentation
For detailed documentation instructions go to [https://www.ibm.com/support/knowledgecenter/en/SSPREK/welcome.html](https://www.ibm.com/support/knowledgecenter/en/SSPREK/welcome.html).

# Required configuration changes for lightweight containers
The new lightweight runtime container in v10.0.2.0 and above do not listen on port 443.  Instead it listens on port 9443.  You will need to update junctions and WRP configuration items that reference the runtime to set this new port.

The new lightweight DSC containers in v10.0.2.0 and above do not listen on ports 443 and 444. Instead they listen on ports 9443 and 9444.  You will need to update you cluster configuration to reflect this change.

The new lightweight reverse proxy container in v10.0.2.0 and above do not listen on port 443.  Instead it listens on port 9443.  You may need to update ingress or loadbalancer configurations to reflect this.

# Version History

| Chart | Date | Kubernetes Required | Image(s) Supported | Breaking Changes | Details
| ----- | ---- | ------------------- | ------------------ | ---------------- | -------
| 1.2.0 | July 2020  | >= 1.11.x | ibmcom/verify-access:10.0.0.0; ibmcom/verify-access-postgresql:10.0.0.0; ibmcom/verify-access-openldap:10.0.0.0 | Verify Access | Based on ISAM v1.2.0 charts
| 1.2.1 | Nov 2020  | >= 1.11.x | ibmcom/verify-access:10.0.0.0; ibmcom/verify-access-postgresql:10.0.0.0; ibmcom/verify-access-openldap:10.0.0.0 | Verify Access | Add timezone support
| 1.3.0 | June 2021  | >= 1.11.x | ibmcom/verify-access:10.0.2.0; ibmcom/verify-access-*:10.0.2.0 | Verify Access | Support function-specific containers
| 1.3.1 | Dec 2021  | >= 1.11.x | ibmcom/verify-access:10.0.2.0+; ibmcom/verify-access-*:10.0.2.0+ | Verify Access | Support function-specific containers
