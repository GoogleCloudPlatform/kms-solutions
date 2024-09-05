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

package simple_example

import (
	"context"
	"fmt"
	"io"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
	"golang.org/x/oauth2/google"
)

func TestSimpleExample(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)
	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("autokey_project_id")
		autokeyConfig := bpt.GetStringOutput("autokey_config")

		autokeyConfigUrl := fmt.Sprintf("https://cloudkms.googleapis.com/v1/%s", autokeyConfig)

		httpClient, err := google.DefaultClient(context.Background(), "https://www.googleapis.com/auth/cloud-platform")

		if err != nil {
			return
		}

		resp, err := httpClient.Get(autokeyConfigUrl)
		if err != nil {
			return
		}

		defer resp.Body.Close()
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			return
		}

		result := utils.ParseJSONResult(t, string(body))

		autokeyConfigProject := result.Get("keyProject").String()
		assert.Equal(autokeyConfigProject, fmt.Sprintf("projects/%s", projectId), "autokey expected for project %s", projectId)
	})

	bpt.Test()
}
