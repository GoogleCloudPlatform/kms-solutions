# Raw Encryption: Building infrastructure for sharing encrypted data with partners

## Overview

This guide provides patterns that can be used to continuously share sensitive data in encrypted form from external sources (on-prem or other clouds) with partners using the raw encryption feature in Cloud KMS with Terraform.

## Context

This automation is based in two personas: **producer** and **consumer**.

**Producer** is the entity that will generate the DEK (Data Encryption Key) and wants to send the encrypted data, while the **consumer** is the entity that will create the required GCP resources in order to receive the wrapped DEK together with the data to be decrypted.

## Expected workflow

1. Consumer [0-bootstrap terraform module](./consumer/0-bootstrap/README.md) execution;
1. Consumer sends the Import Job public key generated to Producer;
1. Producer [terraform module](./producer/README.md) execution;
1. Producer [encrypt process](./examples/python/README.md) execution;
1. Producer sends the wrapped DEK and the encrypted data to Consumer;
1. Consumer [1-key-import terraform module](./consumer/0-bootstrap/README.md) execution;
1. Consumer [decrypt process](./examples/python/README.md) execution;
