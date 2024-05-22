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
	"os/exec"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestApacheWebServerModule(t *testing.T) {
	apacheT := tft.NewTFBlueprintTest(t)
	apacheT.DefineVerify(func(assert *assert.Assertions) {
		apacheT.DefaultVerify(assert)

		gcloud.Run(t, fmt.Sprintf("compute ssh --zone us-central1-a username@%s --tunnel-through-iap --project %s --impersonate-service-account %s", apacheT.GetStringOutput("vm_hostname"), apacheT.GetStringOutput("project_id"), apacheT.GetStringOutput("service_account")))
		exec.Command("container_id=$(docker ps -q | head -n 1)")
		op := exec.Command("docker exec $container_id curl -v --insecure https://127.0.0.1")

		assert.Contains(op.String(), "HTTP/1.1 200 OK")
	})
	apacheT.Test()
}
