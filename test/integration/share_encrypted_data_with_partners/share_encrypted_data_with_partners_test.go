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

package share_encrypted_data_with_partner

import (
	"os"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestShareEncryptedDataModule(t *testing.T) {
	cryptT := tft.NewTFBlueprintTest(t)
	cryptT.DefineVerify(func(assert *assert.Assertions) {
		cryptT.DefaultVerify(assert)

		filePath := "../../../examples/share_encrypted_data_with_partners/decrypted_text.txt"
		data, err := os.ReadFile(filePath)

		assert.Contains(string(data), "plaintext: \"a secret message to be shared\"", "Expected decrypted plaintext message not found!")
		assert.Nil(err)
	})
	cryptT.Test()
}
