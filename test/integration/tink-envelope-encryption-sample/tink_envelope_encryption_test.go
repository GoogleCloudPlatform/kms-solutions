// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package tink_envelope_encryption_sample

import (
	"os"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestTinkEnvelopeModule(t *testing.T) {
	tinkT := tft.NewTFBlueprintTest(t)
	tinkT.DefineVerify(func(assert *assert.Assertions) {
		tinkT.DefaultVerify(assert)

		filePath := "../../../examples/tink-envelope-encryption-sample/decrypted_file"
		data, err := os.ReadFile(filePath)

		assert.Contains(string(data), "sensitive text", "Expected decrypted plaintext message not found!")
		assert.Nil(err)
	})
	tinkT.Test()
}
