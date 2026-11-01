import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from validate_cidrs import validate_cidrs


class TestCidrValidation(unittest.TestCase):
    def test_valid_design(self):
        self.assertTrue(validate_cidrs("10.42.0.0/16", "10.42.1.0/24", "10.42.2.0/24"))

    def test_rejects_overlap(self):
        with self.assertRaisesRegex(ValueError, "overlap"):
            validate_cidrs("10.42.0.0/16", "10.42.1.0/24", "10.42.1.128/25")

    def test_rejects_outside_vnet(self):
        with self.assertRaisesRegex(ValueError, "inside"):
            validate_cidrs("10.42.0.0/16", "10.42.1.0/24", "10.99.2.0/24")

    def test_rejects_invalid_ipv4_range(self):
        with self.assertRaises(ValueError):
            validate_cidrs("10.42.0.0/16", "10.42.1.0/24", "not-a-cidr")


if __name__ == "__main__":
    unittest.main()
