// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS-IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"context"
	"errors"
	"flag"
	"log"
	"os"

	"github.com/google/tink/go/aead"
	"github.com/google/tink/go/core/registry"
	"github.com/google/tink/go/integration/gcpkms"
	"github.com/google/tink/go/keyset"
	"github.com/google/tink/go/tink"
	"google.golang.org/api/option"
)

var (
	mode           = flag.String("mode", "", "The operation to perform: generate, encrypt, or decrypt")
	keysetPath     = flag.String("keyset_path", "", "Path to the keyset used for encryption")
	kekURI         = flag.String("kek_uri", "", "The Cloud KMS URI of the key encryption key")
	gcpCredential  = flag.String("gcp_credential_path", "", "Path to the GCP credentials JSON file")
	inputPath      = flag.String("input_path", "", "Path to the input file")
	outputPath     = flag.String("output_path", "", "Path to the output file")
	associatedData = flag.String("associated_data", "", "Optional associated data to use with the encryption operation")
)

func main() {
	flag.Parse()

	// load master key
	ctx := context.Background()
	gcpClient, err := gcpkms.NewClientWithOptions(ctx, *kekURI, option.WithCredentialsFile(*gcpCredential))
	if err != nil {
		log.Fatal(err)
	}
	registry.RegisterKMSClient(gcpClient)

	masterKey, err := gcpClient.GetAEAD(*kekURI)
	if err != nil {
		log.Fatal(err)
	}

	switch *mode {
	case "generate":
		if err := generateKeyset(*outputPath, masterKey); err != nil {
			log.Fatalf("Error generating keyset: %v", err)
		}
	case "encrypt", "decrypt":
		if err := processFile(*mode, *outputPath, *inputPath, *keysetPath, *associatedData, masterKey); err != nil {
			log.Fatalf("Error: %v", err)
		}
	default:
		log.Fatalf("Unsupported mode %s. Please choose 'generate', 'encrypt', or 'decrypt'", *mode)
	}
}

func generateKeyset(outputPath string, masterKey tink.AEAD) error {

	var err error
	// create output file
	_, err = os.Stat(outputPath)
	if err == nil {
		log.Fatal(errors.New("output file must not exist"))
	}
	f, err := os.Create(outputPath)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	// generate a new key
	keyTemplate := aead.AES256GCMKeyTemplate()
	handle, err := keyset.NewHandle(keyTemplate)

	// write the new key
	keyWriter := keyset.NewJSONWriter(f)
	if err := handle.Write(keyWriter, masterKey); err != nil {
		log.Fatal(err)
	}

	return nil
}

func processFile(mode string, outputPath string, inputPath string, keysetPath string, associatedData string, masterKey tink.AEAD) error {
	// Read the encrypted keyset
	keysetFile, err := os.Open(keysetPath)
	if err != nil {
		log.Fatal("error opening keyset file: %v", err)
	}
	defer keysetFile.Close()

	keysetHandle, err := keyset.Read(keyset.NewJSONReader(keysetFile), masterKey)
	if err != nil {
		log.Fatal("error reading encrypted keyset: %v", err)
	}

	// Get the primitive
	cipher, err := aead.New(keysetHandle)
	if err != nil {
		log.Fatal("error getting primitive: %v", err)
	}

	// Read the input file
	inputData, err := os.ReadFile(inputPath)
	if err != nil {
		log.Fatal("error reading input file: %v", err)
	}

	var outputData []byte
	if mode == "encrypt" {
		outputData, err = cipher.Encrypt(inputData, []byte(associatedData))
		if err != nil {
			log.Fatal("error encrypting data: %v", err)
		}
	}

	if mode == "decrypt" {
		outputData, err = cipher.Decrypt(inputData, []byte(associatedData))
		if err != nil {
			log.Fatal("error decrypting data: %v", err)
		}
	}

	// Write the output file
	if err := os.WriteFile(outputPath, outputData, 0644); err != nil {
		log.Fatal("error writing output file: %v", err)
	}

	return nil
}
