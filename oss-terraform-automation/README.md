# Terraform automation for example use cases on Cloud KMS using PKCS #11

PKCS #11 is a standard that specifies an API for managing cryptographic keys, and performing operations with them.
Cloud KMS provides a library that conforms to this standard, in order to interoperate with existing applications that consume the PKCS #11 API.

This repository contains two terraform automated use cases examples for that library:

- [Use a Cloud HSM key to serve Apache traffic](./1-apache-web-server/README.md)
- [Use a Cloud HSM key for TLS offloading with NGINX](./2-nginx-ssl-offloading/README.md)

You can find the PKCS #11 library documentation and the manual steps used to build this automation [here](https://cloud.google.com/kms/docs/reference/pkcs11-library).

Microsoft Cryptography API: Next Generation (CNG) is an application programming interface that lets application developers add authentication, encoding, and encryption to Windows-based applications.
CNG also lets you perform crypto operations with tools such as Windows signtool through CNG providers installed on the system.
Cloud KMS offers a provider that conforms to this standard, in order to interoperate with existing applications that leverage the CNG API.

This repository contains a terraform automation example for the provider:

- [Use CNG Provider and SignTool to sign Windows artifacts](./3-cng-provider/README.md)

Note that the automation also relies on the PKCS #11 library mentioned above. You can find more information about the CNG provider [here](https://cloud.google.com/kms/docs/reference/cng-provider).
