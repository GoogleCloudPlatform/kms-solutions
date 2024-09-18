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

package assured_workloads_example

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestAssuredWorkloadsModule(t *testing.T) {
	awT := tft.NewTFBlueprintTest(t)
	awT.DefineVerify(func(assert *assert.Assertions) {
		awT.DefaultVerify(assert)

		aw_id := awT.GetStringOutput("aw_id")
		kms_key_id := awT.GetStringOutput("kms_key_id")

		aw_describe_name := gcloud.Runf(t, "assured workloads describe %s", aw_id).Get("name").String()
		kms_key_describe_name := gcloud.Runf(t, "kms keys describe %s", kms_key_id).Get("name").String()

		assert.Equal(aw_id, aw_describe_name)
		assert.Equal(kms_key_id, kms_key_describe_name)

	})
	awT.Test()
}
