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

package apache_web_server

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/stretchr/testify/assert"
)

func TestFakeApacheWebServerModule(t *testing.T) {
	apacheT := tft.NewTFBlueprintTest(t)

	apacheT.DefineApply(func(assert *assert.Assertions) {
		apacheT.DefaultApply(assert)

		projectId := apacheT.GetTFSetupJsonOutput("project_id")
		t.Cleanup(func() {
			logsCmd := fmt.Sprintf("logging read --project=%s", projectId.Str)
			logs := gcloud.Runf(t, logsCmd).Array()
			for _, log := range logs {
				t.Logf("%s build-log: %s", projectId.Str, log.Get("textPayload").String())
			}
		})
	})

	apacheT.DefineVerify(func(assert *assert.Assertions) {
		apacheT.DefaultVerify(assert)

		command := shell.Command{
			Command: "gcloud",
			Args: []string{
				"compute",
				"ssh",
				"--zone",
				"us-central1-a",
				fmt.Sprintf("username@%s", apacheT.GetStringOutput("vm_hostname")),
				"--tunnel-through-iap",
				"--project",
				apacheT.GetStringOutput("project_id"),
				"--impersonate-service-account",
				apacheT.GetStringOutput("service_account_email"),
				"--command",
				`curl -v --insecure https://127.0.0.1`,
			},
		}

		op, err := shell.RunCommandAndGetOutputE(t, command)

		assert.Contains(op, "HTTP/1.1 200 OK", "Request must return 200")
		assert.Contains(op, "SSL certificate verify result: self-signed certificate", "SSL must be verified")
		assert.Nil(err)
	})
	apacheT.Test()
}
