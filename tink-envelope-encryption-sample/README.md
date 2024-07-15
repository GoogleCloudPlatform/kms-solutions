# Envelope encryption with Tink

## Overview

This guide provide an [envelope encryption](https://cloud.google.com/kms/docs/envelope-encryption) sample using [Tink](https://developers.google.com/tink) with Terraform.


## Context

This automation has 4 terraform modules: [0-bootstrap](./0-bootstrap/README.md), [1-encrypt](./1-encrypt/README.md), [2-decrypt](./2-decrypt/README.md) and [3-reencrypt-symmetric-to-envelope](./3-reencrypt-symmetric-to-envelope/README.md).

**0-bootstrap** module is responsible to provide all the required infrastructure (locally and in GCP) in order to encrypt data using a tink encrypted [keyset](https://developers.google.com/tink/design/keysets).

**1-encrypt** module is responsible to envelope encrypt a file using a tink encrypted [keyset](https://developers.google.com/tink/design/keysets).

**2-decrypt** module is responsible to decrypt a file using a tink encrypted [keyset](https://developers.google.com/tink/design/keysets).

**3-reencrypt-symmetric-to-envelope** module is responsible to change a file encryption from [symmetric](https://cloud.google.com/kms/docs/encrypt-decrypt) to [envelope](https://cloud.google.com/kms/docs/client-side-encryption#envelope_encryption_with_tink) using Tink.

## Expected workflow

**Note:** First of all it's important to mention that it is possible to use all the modules individually as demand. For example, you could use directly [1-encrypt](./1-encrypt/README.md) module if you already have the existing GCP and Tink infrastructure for envelope encryption.

#### Envelope encryption from scratch
1. [0-bootstrap module](./consumer/0-bootstrap/README.md) execution;
2. [1-encrypt module](./1-encrypt/README.md) execution;
2. [2-decrypt module](./2-decrypt/README.md) execution;

#### Changing from symmetric encryption to Envelope encryption
1. [0-bootstrap module](./consumer/0-bootstrap/README.md) execution;
2. [3-reencrypt-symmetric-to-envelope](./3-reencrypt-symmetric-to-envelope/README.md) execution;
