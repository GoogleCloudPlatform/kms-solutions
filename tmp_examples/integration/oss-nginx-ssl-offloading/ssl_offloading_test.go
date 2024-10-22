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

package nginx_ssl_offloading

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/stretchr/testify/assert"
)

func TestNginxSslOffloadingModule(t *testing.T) {
	nginxT := tft.NewTFBlueprintTest(t)
	nginxT.DefineVerify(func(assert *assert.Assertions) {
		nginxT.DefaultVerify(assert)

		command := shell.Command{
			Command: "gcloud",
			Args: []string{
				"compute",
				"ssh",
				"--zone",
				"us-central1-a",
				fmt.Sprintf("username@%s", nginxT.GetStringOutput("vm_hostname")),
				"--tunnel-through-iap",
				"--project",
				nginxT.GetStringOutput("project_id"),
				"--impersonate-service-account",
				nginxT.GetStringOutput("service_account_email"),
				"--command",
				`openssl s_client -connect localhost:443 2>&1 <<< "GET /"`,
			},
		}

		shell.RunCommandAndGetOutputE(t, command) // GET does not output in the first execution
		op, err := shell.RunCommandAndGetOutputE(t, command)

		assert.Contains(op, "Welcome to nginx!", "GET request failed")
		assert.Contains(op, "self-signed certificate", "SSL must be verified")
		assert.Contains(op, "SSL handshake has read", "SSL handshake failed")
		assert.Nil(err)
	})
	nginxT.Test()
}
