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
import json
import logging
import os
import shutil
import subprocess
import sys
from typing import List

import gcloud_commands
import ykman_utils


def make_directory(directory_path: str) -> None:
    """Creates a directory with the passed in path if it does not already
       exist.

    Args:
        directory_path: The path of the directory to be created.

    Returns:
        None
    """
    if not os.path.exists(directory_path):
        os.mkdir(directory_path)
        print(f"Directory '{directory_path}' created.")
    else:
        print(f"Directory '{directory_path}' already exists.")



def _parse_and_write_challenges(
    challenges: list, unsigned_challenges: list, directory: str
) -> list:
    """Helper function to parse and write challenges to files.

     Args:
        challenges: A list of challenges from the proposal.
        unsigned_challenges: A list to append the parsed challenges to.

     Returns:
        The updated list of unsigned challenges.
     """
    challenge_count = len(unsigned_challenges)

    make_directory(directory)

    for challenge in challenges:
        challenge_count += 1
        try:
            binary_challenge = ykman_utils.urlsafe_base64_to_binary(
                challenge["challenge"]
            )
            with open(
                f"{directory}/challenge{challenge_count}.txt", "wb"
            ) as f:
                f.write(binary_challenge)

            with open(
                f"{directory}/public_key{challenge_count}.pem", "w"
            ) as f:
                f.write(
                    challenge["publicKeyPem"]
                    .encode("utf-8")
                    .decode("unicode_escape")
                )

            unsigned_challenges.append(
                ykman_utils.Challenge(binary_challenge, challenge["publicKeyPem"])
            )
        except (FileNotFoundError, Exception) as e:
            print(
                f"An error occurred processing challenge {challenge_count}: {e}"
            )
    return unsigned_challenges




def parse_challenges_into_files(sthi_output: str) -> tuple[List[bytes], List[bytes]]:
    """Parses the STHI output and writes the challenges and public keys to files."""
    print("Parsing challenges into files")
    proposal_json = json.loads(sthi_output, strict=False)

    required_challenges_unsigned = []
    quorum_challenges_unsigned = []

    if "requiredActionQuorumParameters" in proposal_json:
        required_challenges = proposal_json["requiredActionQuorumParameters"].get(
            "requiredChallenges", []
        )
        quorum_challenges = proposal_json["requiredActionQuorumParameters"].get(
            "quorumChallenges", []
        )
        required_challenges_unsigned = _parse_and_write_challenges(
            required_challenges, required_challenges_unsigned, "required_challenges"
        )
        quorum_challenges_unsigned = _parse_and_write_challenges(
            quorum_challenges, quorum_challenges_unsigned, "quorum_challenges"
        )
    elif "quorumParameters" in proposal_json:
        challenges = proposal_json["quorumParameters"]["challenges"]
        quorum_challenges_unsigned = _parse_and_write_challenges(
            challenges, quorum_challenges_unsigned, "quorum_challenges"
        )

    return required_challenges_unsigned, quorum_challenges_unsigned


def parse_args(args):
    parser = argparse.ArgumentParser()
    parser.add_argument("--proposal_resource", type=str, required=True)
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
    return parser.parse_args(args)


def signed_challenges_to_files(
    challenge_replies: list[ykman_utils.ChallengeReply],
    signed_challenge_dir_name: str,
) -> None:
    """Writes the signed challenges and public keys to files.

    Args:
        challenge_replies: A list of ChallengeReply objects.

    Returns:
        None
    """
    signed_challenge_files = []
    challenge_count = 0

    if not challenge_replies:
        return

    for challenge_reply in challenge_replies:
        challenge_count += 1
        make_directory(signed_challenge_dir_name)
        with open(
            f"{signed_challenge_dir_name}/public_key_{challenge_count}.pem", "w"
        ) as public_key_file:

            # Write public key to file
            public_key_file.write(challenge_reply.public_key_pem)
        with open(
            f"{signed_challenge_dir_name}/signed_challenge{challenge_count}.bin", "wb"
        ) as binary_file:

            # Write signed challenge to file
            binary_file.write(challenge_reply.signed_challenge)
            signed_challenge_files.append(
                (
                    f"{signed_challenge_dir_name}/signed_challenge{challenge_count}.bin",
                    f"{signed_challenge_dir_name}/public_key_{challenge_count}.pem",
                )
            )
    return signed_challenge_files


def approve_proposal():
    """Approves a proposal by fetching challenges, signing them, and sending
       them back to gcloud."""
    # Clear the unsigned and signed challenge directories if they exist.
    if os.path.exists("signed_required_challenges"):
        shutil.rmtree("signed_required_challenges")
    if os.path.exists("signed_quorum_challenges"):
        shutil.rmtree("signed_quorum_challenges")
    if os.path.exists("signed_challenges"):
        shutil.rmtree("signed_challenges")
    if os.path.exists("required_challenges"):
        shutil.rmtree("required_challenges")
    if os.path.exists("quorum_challenges"):
        shutil.rmtree("quorum_challenges")

    parser = parse_args(sys.argv[1:])

    # Fetch challenges
    process = gcloud_commands.fetch_challenges(parser.proposal_resource)

    # Parse challenges into files
    required_challenges_unsigned, quorum_challenges_unsigned = parse_challenges_into_files(
        process.stdout
    )

    # Sign challenges
    signed_required_challenges = ykman_utils.sign_challenges(
        challenges=required_challenges_unsigned,
        management_key=parser.management_key,
        pin=parser.pin,
    )
    signed_quorum_challenges = ykman_utils.sign_challenges(
        challenges=quorum_challenges_unsigned,
        management_key=parser.management_key,
        pin=parser.pin,
    )

    # Parse signed challenges into files
    signed_required_challenge_files = signed_challenges_to_files(
        signed_required_challenges,
        "signed_required_challenges"
    )
    signed_quorum_challenge_files = signed_challenges_to_files(
        signed_quorum_challenges,
        "signed_quorum_challenges"
    )

    # Return signed challenges to gcloud
    gcloud_commands.send_signed_challenges(
        signed_required_challenge_files,
        signed_quorum_challenge_files,
        parser.proposal_resource,
    )


if __name__ == "__main__":

    try:
        approve_proposal()
    except subprocess.CalledProcessError:
        print("\nAn error occurred while running a gcloud command. The script will now exit.")
        sys.exit(1)