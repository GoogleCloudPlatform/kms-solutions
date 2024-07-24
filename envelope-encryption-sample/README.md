# Envelope encryption

## Overview

This guide provide an [envelope encryption](https://cloud.google.com/kms/docs/envelope-encryption) sample using Terraform.

## Context

This automation has 3 terraform modules: [0-bootstrap](./0-bootstrap/README.md), [1-encrypt](./1-encrypt/README.md), [2-decrypt](./2-decrypt/README.md).

**0-bootstrap** module is responsible to provide all the required infrastructure (locally and in GCP) in order to encrypt data using a wrapped Data Encryption Key (DEK).

**1-encrypt** module is responsible to envelope encrypt a file using a wrapped DEK.

**2-decrypt** module is responsible to decrypt a file using a a wrapped DEK.

## Expected workflow

**Note:** First of all it's important to mention that it is possible to use all the modules individually as demand. For example, you could use directly [1-encrypt](./1-encrypt/README.md) module if you already have the existing GCP and a wrapped DEK for envelope encryption.

#### Envelope encryption from scratch
1. [0-bootstrap module](./consumer/0-bootstrap/README.md) execution;
2. [1-encrypt module](./1-encrypt/README.md) execution;
2. [2-decrypt module](./2-decrypt/README.md) execution;
