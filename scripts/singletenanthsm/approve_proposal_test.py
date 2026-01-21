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

from dataclasses import dataclass

import json

import os

from cryptography.hazmat.primitives.serialization import (
    Encoding,
    PublicFormat,
)

import approve_proposal

import ykman_fake
import ykman_utils


sample_sthi_output = """
{
 "quorumParameters": {
    "challenges": [
      {
        "challenge": "tiOz64M_rJ34yOvweHBBltRrm3k34bou4m2JK\
lz9BmhrR7yU6S6ram8o1VQhyPU1",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\n\
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3WK/NpZ4DJ68lOR7JINL\n\
yODwrRanATJNepJi1LYDDO4ZqQvaOvbv8RR47YBlHYAwEDuUC0Vy9g03T0G7V/TV\n\
TFNQU+I2wIm6VQFFbhjFYYCECILHPNwRp8XN0VKSiTqj5ilPa2wdPsBEgwNKlILn\n\
v9iTx9IdyFeMmCqIWgeFX5sHddvgq5Dep7kBRVh7ZM1+hOS8kw2qmZgKX8Zwgz3E\n\
0En/2r+3YgWtMxTz6iqW/Op0UagrlR5EgysjrNgakJEJQA/x23SataJOpVvSE9pH\n\
SCyzrIaseg1gtz5huDVO5GOK3Xg/VUr2n3sk98MQtHWWaEfcpstSrrefjTC4IYN5\n\
2QIDAQAB\n-----END PUBLIC KEY-----\n"
      },
      {
        "challenge": "6bfZOoD9L35qO1GIzVHcv9sX0UEzKCTru8yz1\
U7NK4o7y0gnXoU3Ak47sFFY4Yzb",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\n\
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwpxT5iX72pkd/m8Fb3mg\n\
MkCQMoWb3FKAjHsutKpUEMA0ts1atZe7WFBRcCxV2mTDeWFpSwWjuYYSNNrEgk9e\n\
BRiLJ/36hCewnzw9PZMPcnWv+QLbyLsr4jAEVHk2pWln2HkVbAmK2OWEhvlUjxyT\n\
fB0b1UsBP3uy5f+SLb8iltvwWZGauT64JrLpbIwhk6SbXOCZSZtsXVZ5mVPEIxik\n\
Z4iBT3r+9Fc3fgKN/16bjdHw+qbWxovEYejG10Yp1yO4QjSzkxQsXTFvsWxaTKF2\n\
cZa5GF19b9ZkY3SRxHF6emA720F+N4oeGuV0Zu/ACYfMqRUSkh5GiOpv6VxvuXRD\n\
0wIDAQAB\n-----END PUBLIC KEY-----\n"
      },
      {
        "challenge": "NNH3Pt3F-OvaeYR_Dynp_nbHMuLaVYBnkG7uJ\
twz2-lShyLaHNjOyjBnL-eGjoRY",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\n\
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsrrPGkxbk08x5CpkUk5y\n\
fWBmfiE4qU4IWaSO9HCBv5uRWJvDqXkKjkcBptwmGFsnzT+owfSe+21nWLOLZqwW\n\
mPbV0bW3e7l3ZUw/4fUga+KJDR5OfkkXWSos1cEMhxsSMnGykhx2/ge9bqY0Edbr\n\
zckOT2un87ThdawveS3hOxTczE+JcgzoI+CUxlPV0c9yJ5iNFZXf1p7wj3Rq2I8X\n\
Al4XyMP/+0TLR5+UTrrxLC4ds4m9EjMPRv4aNJFqzBfb3WBM/DFVvNR82Mt2pfF8\n\
lv6RyZU/vls6vjDl42NK3hckOhEGqQpPmifKgPCaOwdLHg68CjQZ54GWGqyFGzNx\n\
HwIDAQAB\n-----END PUBLIC KEY-----\n"
      }
    ],
    "requiredApproverCount": 3
  }
}

"""

sample_required_challenge_output = """
  "requiredActionQuorumParameters": {
    "quorumChallenges": [
      {
        "challenge": "AAEAAwAAAAAAAAAAAAAAAF7mB8z2T7l2LK04a18IVsNncGNvMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABpRIdeAAAAAAAAAAA=",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA06SZvu7M9BkgPD0rYVtl\n9IeMuzgrmaQvLxu5eABT80TznT5u/FRCuwjXSb6YZNOCSoo/kC71u/oi2sq8v27w\nPppjes7KRpylHrT5kVgUnwxmPw/+Ur2RvvX4JbzkTIQmwm+7nGafN+A/1dOGctg3\njnG11qrIo7/eMv43mJvml9kTWP+TExwjUwOBgyMvfa/cEYA/JihRRwKTAHETkCf5\nzlPoDEUM2PzM7OE/QknFIGMdryIe1mXRT5w+E5bXpBEC2ajPnFNfXzeH27gaZzsZ\npC1FdtJpnzn+fJefPSKp/mhO7tWu/jeoEwSYNA9oxd9TcAqT2vaScoPriQ04qwdX\niwIDAQAB\n-----END PUBLIC KEY-----\n"
      },
      {
        "challenge": "AAEAAwAAAAAAAAAAAAAAAF7mB8z2T7l2LK04a18IVsNncGNvMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABpRIdeAAAAAAAAAAA=",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7deo23m4agm3w5svL0wp\nAbAEPK54wx/6bwvNt7wPFo0H91VW27tXtoZ/+GGPIitOoDz9LTHoObIFdJDG3b9w\nqfKtIL79D25YvSiaX+AXB/W4Y6hv27noAODL8E5DvuRxRLEgvCk7/McMq2a2EtEc\nXrv1qljZk1qwfelhLQl9VyjXfujPiBoxjFH3/H34/xHFYSAq9cC2G1BkUgCuH6n5\nE0gMN3BrexJSSlqBnx+6+jP8bBDZRVoOgzuTxzuVMVGpUNZVxSu4uBaQw73P5sQ5\noJdt0D6FR5S/PFlokfMfyrCJj3gMNTHJaQ4divSMU8l3Qr8evlPv34iG4P72/1Rd\nbwIDAQAB\n-----END PUBLIC KEY-----\n"
      },
      {
        "challenge": "AAEAAwAAAAAAAAAAAAAAAF7mB8z2T7l2LK04a18IVsNncGNvMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABpRIdeAAAAAAAAAAA=",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtalWgpoRePYDLRlkRQeO\nWyBKiZ6lHiiDeA2IDReEMjEvym9DEXogl6HRpSgvESHyzcrwmHd5b292Wh+Q1PhC\n+YRwZB0g280/zugA1yX5KQFKnRl7QuyGVEZL6CmhgtWzpcJoB87siJb43XhTnAcC\nhy3Mr0pyfN1jhk/Noh/xd7Tez8Z6yoihE6iJVxkaHL5N9nR5AKjP2jIo4Uko+XAh\npXTfkk0KTDvBYgbHTDKiliyPKQl0qbPNqBnZijaXRnI9BQpIKi+9ex90tF472pNF\nASaFFi8jHgY19IKfQvYPCKCst2Zyl9rDnYwDfDIeUDIJTLeycUTDgM2IgqrMQNHA\nawIDAQAB\n-----END PUBLIC KEY-----\n"
      }
    ],
    "requiredApproverCount": 2,
    "requiredChallenges": [
      {
        "challenge": "M9hHtA6mQ7WeRXUplBQDUF13KBmD2EHC06ypuNHWK9BK3v05dgbVBvlIaWtw5Smn",
        "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Dxt9ptrzHiXclVwOBin\nKhjdWX/a6sIKXKKnItlmc6gN+CfzUetQ7bEih/INtNrrVW75p5jM1uUTmjrrQ5Yh\n2H+p2EgHs3NS9CK2aMJxFoSRMc12BQGSpXwWhH9F9HVIcCretM70TrnOFr+6FBIq\nVM1efRKbUTvA1gsXt235Swv35u0CsGXmebaWU+sFSloQuXro+O9f32XN+Ff/MNEA\nxZb1+ae/z5+NeXriIBKmMBGNBVE/se5L/mdC27LLRZi+A2xSlbaQB6nta8kzw0gn\n3RYJ7KqLtbXDISROvUEUp3iX6qmjiIWsxM/HhO7+5y5URdUqFVtRTl3FGKMPmweh\nRwIDAQAB\n-----END PUBLIC KEY-----\n"
      }
    ]
  }
"""

@dataclass
class QuorumParameters:
    challenges: list[ykman_utils.Challenge]


mock_signed_quorum_challenges = []
mock_signed_required_challenges = []

test_resource = "projects/my-project/locations/us-east1/" \
                "singleTenantHsmInstances/mysthi/proposals/my_proposal"
# mock_completed_process = subprocess.CompletedProcess


def public_key_to_pem(public_key):
    public_key_pem = public_key.public_bytes(
        encoding=Encoding.PEM, format=PublicFormat.SubjectPublicKeyInfo
    ).decode("utf-8")
    print("PUBLIC KEY--------------")
    print(public_key_pem)
    return public_key_pem


def create_json(public_key_pem_1, public_key_pem_2, public_key_pem_3):

    my_json_string = json.dumps(
        {
            "quorumParameters": {
                "challenges": [
                    {
                        "challenge": "tiOz64M_rJ34yOvweHBBltRrm3k34bou"
                        "4m2JKlz9BmhrR7yU6S6ram8o1VQhyPU1",
                        "publicKeyPem": public_key_pem_1,
                    },
                    {
                        "challenge": "6bfZOoD9L35qO1GIzVHcv9sX0UEzKCTr"
                        "u8yz1U7NK4o7y0gnXoU3Ak47sFFY4Yzb",
                        "publicKeyPem": public_key_pem_2,
                    },
                    {
                        "challenge": "NNH3Pt3F-OvaeYR_Dynp_nbHMuLaVYBn"
                        "kG7uJtwz2-lShyLaHNjOyjBnL-eGjoRY",
                        "publicKeyPem": public_key_pem_3,
                    },
                ],
                "requiredApproverCount": 3,
            }
        }
    )
    return my_json_string


def create_fake_fetch_response(num_keys=3):
    """
    Generates a fake fetch response with a specified number of RSA key pairs.

    Args:
        num_keys: The number of RSA key pairs to generate.

    Returns:
        A tuple containing:
          - A JSON object with the public keys.
          - A dictionary mapping public key PEMs to private keys.
    """
    pub_to_priv_key = {}
    public_key_pems = []

    for _ in range(num_keys):
        private_key, public_key = ykman_fake.generate_rsa_keys()
        public_key_pem = public_key_to_pem(public_key)
        pub_to_priv_key[public_key_pem] = private_key
        public_key_pems.append(public_key_pem)

    challenge_json = create_json(*public_key_pems)  # Use * to unpack the list
    return challenge_json, pub_to_priv_key


def sign_challenges_with_capture(
    challenges: list[ykman_utils.Challenge], pub_to_priv_key
):
    signed_challenges = []
    for challenge in challenges:
        private_key = pub_to_priv_key[challenge.public_key_pem]
        signed_challenge = ykman_fake.sign_data(
            private_key, challenge.challenge)
        signed_challenges.append(
            ykman_utils.ChallengeReply(
                challenge.challenge, signed_challenge, challenge.public_key_pem
            )
        )
    mock_signed_required_challenges.extend(signed_challenges)
    return signed_challenges


def verify_with_fake(pub_to_priv_key, signed_required_challenges, signed_quorum_challenges):
    for signed_required_challenge in signed_required_challenges:
        priv_key = pub_to_priv_key[signed_required_challenge.public_key_pem]
        assert ykman_fake.verify_signature(
            priv_key.public_key(),
            signed_required_challenge.unsigned_challenge,
            signed_required_challenge.signed_challenge,
        )
    for signed_quorum_challenge in signed_quorum_challenges:
        priv_key = pub_to_priv_key[signed_quorum_challenge.public_key_pem]
        assert ykman_fake.verify_signature(
            priv_key.public_key(),
            signed_quorum_challenge.unsigned_challenge,
            signed_quorum_challenge.signed_challenge,
        )
    print("Signed verified successfully")


def test_get_quorum_challenges_mocked(mocker, monkeypatch):
    # Verify signed challenges
    monkeypatch.setattr(
        "gcloud_commands.send_signed_challenges",
        lambda signed_required_challenge_files, signed_quorum_challenge_files,  proposal_resource: verify_with_fake(
            pub_to_priv_key, mock_signed_quorum_challenges,
            mock_signed_required_challenges,
        ),
    )

    # monkeypatch sign challenges
    monkeypatch.setattr(
        "ykman_utils.sign_challenges",
        lambda challenges, **kwargs: sign_challenges_with_capture(
            challenges, pub_to_priv_key
        ),
    )

    # mock the challenge string returned by service
    challenge_json, pub_to_priv_key = create_fake_fetch_response()
    mock_response = mocker.MagicMock()
    mock_response.stdout = challenge_json
    mocker.patch("subprocess.run", return_value=mock_response)

    # monkeypatch parse args
    monkeypatch.setattr(
        "approve_proposal.parse_args",
        lambda args: argparse.Namespace(
            proposal_resource="test_resource",
            management_key="test_management_key",
            pin="123456",
        ),
    )
    approve_proposal.approve_proposal()

    # assert challenge files created
    challenge_files = [
        "quorum_challenges/challenge1.txt",
        "quorum_challenges/challenge2.txt",
        "quorum_challenges/challenge3.txt",
    ]
    for file_path in challenge_files:
        assert os.path.exists(
            file_path
        ), f"File '{file_path}' should exist but does not."

def test_approve_quorum_challenges():
        # Parse challenges into files
    unsigned_challenges = approve_proposal.parse_challenges_into_files(
        sample_sthi_output
    )
    created_signed_files = [
        "signed_quorum_challenges/signed_challenge1.bin",
        "signed_quorum_challenges/signed_challenge2.bin",
        "signed_quorum_challenges/signed_challenge3.bin",
    ]
    for file_path in created_signed_files:
        assert os.path.exists(
            file_path
        ), f"File '{file_path}' should exist but does not."

    # assert signed challenge files created
    signed_challenge_files = [
        "signed_quorum_challenges/signed_challenge1.bin",
        "signed_quorum_challenges/signed_challenge2.bin",
        "signed_quorum_challenges/signed_challenge3.bin",
    ]
    for file_path in signed_challenge_files:
        assert os.path.exists(
            file_path
        ), f"File '{file_path}' should exist but does not."

    # Parse files into challenge list
    challenges = ykman_utils.populate_challenges_from_files()
    for challenge in challenges:
        unsigned_challenges.append(challenge.challenge)
    signed_challenged_files = []
    signed_challenges = ykman_utils.sign_challenges(
        challenges, signed_challenged_files)
    # for signed_challenge in signed_challenges:
    #     print(signed_challenge.signed_challenge)
    #     print(signed_challenge.public_key_pem)
    ykman_utils.verify_challenge_signatures(signed_challenges)

