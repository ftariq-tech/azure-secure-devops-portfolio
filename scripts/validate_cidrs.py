"""Validate proposed Azure IPv4 network ranges without contacting Azure.

This checks only IPv4 CIDR containment and overlap. It is not a security scan.
"""
import argparse
import ipaddress


def validate_cidrs(vnet_cidr, app_cidr, ops_cidr):
    vnet = ipaddress.ip_network(vnet_cidr, strict=True)
    app = ipaddress.ip_network(app_cidr, strict=True)
    ops = ipaddress.ip_network(ops_cidr, strict=True)
    if any(item.version != 4 for item in (vnet, app, ops)):
        raise ValueError("This demo supports IPv4 only")
    if not app.subnet_of(vnet) or not ops.subnet_of(vnet):
        raise ValueError("Both subnets must fit inside the VNet")
    if app.overlaps(ops):
        raise ValueError("Application and operations subnet CIDRs overlap")
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vnet", default="10.42.0.0/16")
    parser.add_argument("--app", default="10.42.1.0/24")
    parser.add_argument("--ops", default="10.42.2.0/24")
    args = parser.parse_args()
    try:
        validate_cidrs(args.vnet, args.app, args.ops)
    except (ValueError, ipaddress.AddressValueError) as exc:
        parser.exit(1, f"CIDR validation failed: {exc}\n")
    print("CIDR checks passed: both subnets are within the VNet and do not overlap.")


if __name__ == "__main__":
    main()
