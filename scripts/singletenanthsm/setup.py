#!/usr/bin/env python

# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import argparse

import gcloud_commands
import ykman_utils


def confirm_action(prompt: str) -> bool:
  """Asks the user for confirmation before proceeding.

  Args:
    prompt: The message to display to the user.

  Returns:
    True if the user confirms, False otherwise.
  """
  while True:
    response = input(f"{prompt} [y/N]: ").lower().strip()
    if response in ('y', 'yes'):
      return True
    elif response in ('n', 'no', ''):  # Default to 'no'
      return False
    else:
      print("Invalid input. Please enter 'y' or 'n'.")


def validate_operation(operation: str, management_key: str, pin: str):
    if operation == "generate_rsa_keys":
        confirmation_prompt = (
            "WARNING: You are about to regenerate the RSA keys. This action is "
            "irreversible and may lead to loss of access to encrypted data.\n"
            "Are you sure you want to continue?"
        )

        if not confirm_action(confirmation_prompt):
            print("RSA key regeneration cancelled.")
            return

        try:
            if not management_key or not pin:
                raise ValueError(
                    "--management_key and --pin need to be specified for the "
                    "generate_rsa_keys operation"
                )
            ykman_utils.generate_private_key(
                management_key=management_key, pin=pin)
        except Exception as e:
            if not management_key or not pin:
                raise ValueError(
                    "--management_key and --pin need to be specified for the "
                    "generate_rsa_keys operation"
                )
            raise Exception(f"Generating private keys failed {e}")
    else:
        raise Exception(
            "Operation type not valid. Operation flag value must be "
            "generate_rsa_keys "
        )


def generate_private_keys_build_gcloud(management_key: str, pin: str):
    """Generates an RSA key on slot 82 of every yubikey
    connected to the local machine and builds the custom gcloud cli.
    """
    try:
        ykman_utils.generate_private_key(
            management_key=management_key, pin=pin)
    except Exception as e:
        raise Exception(f"Generating private keys failed {e}")
    try:
        gcloud_commands.build_custom_gcloud()
    except Exception as e:
        raise Exception(f"Generating custom gcloud build failed {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--operation",
        type=str,
        choices=[
            "generate_rsa_keys",
        ],
        required=True,
    )
    parser.add_argument(
        "--management_key",
        type=str,
        required=False,
    )
    parser.add_argument(
        "--pin",
        type=str,
        required=False,
    )
    args = parser.parse_args()
    validate_operation(args.operation, args.management_key, args.pin)
