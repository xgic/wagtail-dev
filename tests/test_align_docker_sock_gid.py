"""Unit tests for Docker engine socket GID alignment."""

from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = (
    REPO_ROOT
    / ".devcontainer"
    / "scripts"
    / "align_docker_sock_gid.py"
)


def _load():
    spec = importlib.util.spec_from_file_location(
        "align_docker_sock_gid", SCRIPT
    )
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


class AlignDockerSockGidTests(unittest.TestCase):
    def test_plan_groupmod_when_image_gid_differs(self) -> None:
        mod = _load()
        plan = mod.plan_align(
            123,
            docker_gid=994,
            gid_owners={994: "docker", 1000: "vscode"},
        )
        self.assertEqual(plan.reason, "groupmod-docker")
        self.assertEqual(plan.groupmod_docker_to, 123)
        self.assertEqual(plan.add_user_to_groups, ("docker",))

    def test_plan_already_matched_still_ensures_membership(self) -> None:
        mod = _load()
        plan = mod.plan_align(
            123,
            docker_gid=123,
            gid_owners={123: "docker"},
        )
        self.assertEqual(plan.reason, "already-matched")
        self.assertIsNone(plan.groupmod_docker_to)
        self.assertEqual(plan.add_user_to_groups, ("docker",))

    def test_plan_joins_existing_group_that_owns_gid(self) -> None:
        mod = _load()
        plan = mod.plan_align(
            123,
            docker_gid=994,
            gid_owners={123: "staff", 994: "docker"},
        )
        self.assertEqual(plan.reason, "join-existing-gid-group")
        self.assertIsNone(plan.groupmod_docker_to)
        self.assertEqual(plan.add_user_to_groups, ("staff",))

    def test_plan_skips_root_owned_or_missing_socket(self) -> None:
        mod = _load()
        missing = mod.plan_align(
            None, docker_gid=994, gid_owners={994: "docker"}
        )
        root = mod.plan_align(0, docker_gid=994, gid_owners={994: "docker"})
        self.assertEqual(missing.reason, "no-group-socket")
        self.assertEqual(root.reason, "no-group-socket")
        self.assertIsNone(missing.groupmod_docker_to)
        self.assertIsNone(root.groupmod_docker_to)


if __name__ == "__main__":
    unittest.main()
