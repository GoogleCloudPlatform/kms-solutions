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

package autokey_storage

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestAutokeyStorageExample(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)
	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		keyProjectId := bpt.GetStringOutput("autokey_key_project_id")
		autokeyFolderId := bpt.GetStringOutput("autokey_folder_id")
		resourceProjectId := bpt.GetStringOutput("autokey_resource_project_id")
		autokeyKeyHandle := bpt.GetJsonOutput("autokey_storage_keyhandle")
		bucketName := bpt.GetStringOutput("bucket_name")

		prj := gcloud.Runf(t, "projects describe %s", keyProjectId)
		assert.Equal("ACTIVE", prj.Get("lifecycleState").String(), fmt.Sprintf("project %s should be ACTIVE", keyProjectId))
		enabledKmsApi := gcloud.Runf(t, "services list --filter cloudkms.googleapis.com --project %s", keyProjectId).String()
		assert.Contains(enabledKmsApi, "cloudkms.googleapis.com", "KMS API should have been enabled")

		folder := gcloud.Runf(t, "resource-manager folders describe %s", autokeyFolderId)
		assert.Equal("ACTIVE", folder.Get("lifecycleState").String(), fmt.Sprintf("folder %s should be ACTIVE", autokeyFolderId))

		bucketObj := gcloud.Runf(t, fmt.Sprintf("alpha storage buckets describe gs://%s --project %s", bucketName, resourceProjectId))
		assert.True(bucketObj.Exists(), "bucket %s should exist", bucketName)
		assert.Equal(bucketObj.Get("default_kms_key").String(), autokeyKeyHandle.Get("kms_key").String())
	})

	bpt.Test()
}
