// Copyright 2026 Google LLC
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

package pqr_kms_signing

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/stretchr/testify/assert"
)

// samplePdf is a minimal PDF document used as the payload to sign.
const samplePdf = `%PDF-1.4
1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj
2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj
3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] >> endobj
trailer << /Root 1 0 R >>
%%EOF
`

func TestPQRSigningModule(t *testing.T) {
	pqrT := tft.NewTFBlueprintTest(t)
	pqrT.DefineVerify(func(assert *assert.Assertions) {
		pqrT.DefaultVerify(assert)

		kmsKeyUri := pqrT.GetStringOutput("kms_key_uri")

		absPath, _ := filepath.Abs("../../../pqr-kms-signing/sign-verify")
		signScript := filepath.Join(absPath, "sign.sh")
		verifyScript := filepath.Join(absPath, "verify.sh")

		tmpDir, err := os.MkdirTemp("", "pqr_test")
		assert.NoError(err)
		defer os.RemoveAll(tmpDir)

		testPdf := filepath.Join(tmpDir, "sample.pdf")
		testSig := filepath.Join(tmpDir, "sample.sig")

		input := []byte(samplePdf)
		err = os.WriteFile(testPdf, input, 0644)
		assert.NoError(err)

		os.Setenv("KMS_KEY_URI", kmsKeyUri)
		defer os.Unsetenv("KMS_KEY_URI")

		signCmd := shell.Command{
			Command:    "/bin/bash",
			Args:       []string{signScript, testPdf},
			WorkingDir: absPath,
		}
		_, err = shell.RunCommandAndGetOutputE(t, signCmd)
		assert.NoError(err, "Sign script failed")
		assert.FileExists(testSig, "Signature file should be created")

		verifyCmd := shell.Command{
			Command:    "/bin/bash",
			Args:       []string{verifyScript, testPdf, testSig},
			WorkingDir: absPath,
		}
		verifyOp, err := shell.RunCommandAndGetOutputE(t, verifyCmd)
		assert.NoError(err, "Verify script failed")
		assert.Contains(verifyOp, "Signature is VALID!", "Signature verification should succeed")

		err = os.WriteFile(testPdf, append(input, []byte("tampered content")...), 0644)
		assert.NoError(err, "Failed to tamper with PDF")

		_, err = shell.RunCommandAndGetOutputE(t, verifyCmd)
		assert.Error(err, "Verify script should fail on tampered content")

	})
	pqrT.Test()
}
