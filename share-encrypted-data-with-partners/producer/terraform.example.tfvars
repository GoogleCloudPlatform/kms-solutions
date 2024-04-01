/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data_encryption_key_path = "REPLACE-WITH-YOUR-DEK-PATH" # Replace with "./random_datakey.bin" if you ran the testing optional step.
key_encryption_key_path  = "REPLACE-WITH-YOUR-KEK-PATH" # Replace with a public key file path that you might have received from consumer.
wrapped_key_path         = "./wrapped-key"              # Desired wrapped key path
