# Envelope encryption

## Overview

This guide provides an [envelope encryption](https://cloud.google.com/kms/docs/envelope-encryption) sample using Terraform.

## Context

This automation has 3 terraform modules: [0-bootstrap](./0-bootstrap/README.md), [1-encrypt](./1-encrypt/README.md), [2-decrypt](./2-decrypt/README.md).

**0-bootstrap** module is responsible to provide all the required infrastructure (locally and in GCP) in order to encrypt data using a wrapped Data Encryption Key (DEK).

**1-encrypt** module is responsible to envelope encrypt a file using a wrapped DEK.

**2-decrypt** module is responsible to decrypt a file using a a wrapped DEK.

## Expected workflow

**Note:** all the modules can be used individually on demand. For example, you can jump directly to step 2 and use the [1-encrypt](./1-encrypt/README.md) module if you already have the required GCP resources and a wrapped DEK for envelope encryption.

**Note 2:** The local encryption/decryption is done using Python's Fernet package, which uses AES128-CBC + HMAC-SHA256 behind the scenes.

#### Envelope encryption from scratch
1. [0-bootstrap module](./consumer/0-bootstrap/README.md) execution;
2. [1-encrypt module](./1-encrypt/README.md) execution;
2. [2-decrypt module](./2-decrypt/README.md) execution;
