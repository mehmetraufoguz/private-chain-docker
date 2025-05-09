import argparse
from eth_account import Account
from eth_keyfile import create_keyfile_json
import os
import json

# Setup argparse to accept the password and file path from command-line args
def parse_arguments():
    parser = argparse.ArgumentParser(description="Generate Ethereum keystore file.")
    parser.add_argument('password', type=str, help="Password for the keystore")
    parser.add_argument('path', type=str, help="Directory path to save the keystore file")
    return parser.parse_args()

def generate_keystore(password, path):
    # Generate a new account
    account = Account.create()

    # Access the private key correctly
    private_key = account.key  # Corrected: use `account.key` instead of `account.privateKey`

    # Encode the password as bytes (required by the keyfile creation function)
    password_bytes = password.encode('utf-8')  # Ensure password is in byte format

    # Create keystore file (in JSON format)
    keyfile = create_keyfile_json(private_key, password_bytes)

    # Create the specified directory if it doesn't exist
    os.makedirs(path, exist_ok=True)

    # Define the keystore filename using the account address
    keystore_filename = f"UTC--{account.address}.json"
    keystore_path = os.path.join(path, keystore_filename)

    # Save the keystore JSON to a file
    with open(keystore_path, 'w') as keystore_file:
        json.dump(keyfile, keystore_file, indent=4)

    print(f"Keystore file saved at: {keystore_path}")
    print(f"Account address: {account.address}")

# Main entry point
if __name__ == '__main__':
    args = parse_arguments()  # Parse command-line arguments
    generate_keystore(args.password, args.path)  # Generate keystore with provided password and path
