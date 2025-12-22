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

import logging
import subprocess


command_gcloud_describe_proposal = """
  gcloud \
  kms single-tenant-hsm proposal describe """


def fetch_challenges(sthi_proposal_resource: str):
    """Fetches challenges from the server."""
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    try:
        command = (
            command_gcloud_describe_proposal
            + sthi_proposal_resource
            + " --format=json"
        )
        print("\nFetching challenges")
        process = subprocess.run(
            command,
            capture_output=True,
            check=True,
            text=True,
            shell=True,
        )
        print("gcloud command to fetch challenges executed successfully.")
        return process
    except subprocess.CalledProcessError as e:
        logger.exception(f"Fetching challenges failed: {e}")
        raise subprocess.CalledProcessError(
            e.returncode, e.cmd, e.output, e.stderr)


command_gcloud_approve_proposal = [
    "~/sthi/google-cloud-sdk/bin/gcloud",
    "kms",
    "single-tenant-hsm",
    "proposal",
    "approve",
]


def send_signed_challenges(
    signed_required_challenge_files: list,
    signed_quorum_challenge_files: list,
    proposal_resource: str,
):
    """Sends the signed challenges back to gcloud to approve the proposal."""
    command = [
        "gcloud",
        "kms",
        "single-tenant-hsm",
        "proposal",
        "approve",
        proposal_resource,
        "--format=json",
    ]

    if signed_required_challenge_files:
        # Manually construct the string for required replies to avoid spaces
        required_replies = ",".join(
            [f"('{f[0]}','{f[1]}')" for f in signed_required_challenge_files]
        )
        command.append(f"--required-challenge-replies=[{required_replies}]")

    if signed_quorum_challenge_files:
        # Manually construct the string for quorum replies to avoid spaces
        quorum_replies = ",".join(
            [f"('{f[0]}','{f[1]}')" for f in signed_quorum_challenge_files]
        )
        command.append(f"--quorum-challenge-replies=[{quorum_replies}]")

    try:
        process = subprocess.run(
            command,
            check=True,
            capture_output=True,
            text=True,
        )
        print("gcloud command to approve challenges executed successfully.")
        return process
    except subprocess.CalledProcessError as e:
        print(f"Error approving proposal: {e.stderr}\n")
        print(f"Error calling command:\n{" ".join(command)}")
