# ERC721 Dynamic SVG

**⚠️ This project is not audited, use at your own risk**

## Table of Contents

- [ERC721 Dynamic SVG](#erc721-dynamic-svg)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
    - [Key Features](#key-features)
    - [Architecture](#architecture)
    - [Environment Setup](#environment-setup)
  - [Usage](#usage)
    - [Build](#build)
    - [Testing](#testing)
    - [Test Coverage](#test-coverage)
    - [Deploy Locally](#deploy-locally)
    - [Interact with Contract](#interact-with-contract)
  - [Deployment](#deployment)
    - [Deploy to Testnet](#deploy-to-testnet)
    - [Verify Contract](#verify-contract)
    - [Deployment Addresses](#deployment-addresses)
  - [Security](#security)
    - [Audit Status](#audit-status)
    - [Access Control (Roles \& Permissions)](#access-control-roles--permissions)
    - [Known Limitations](#known-limitations)
  - [Gas Optimization](#gas-optimization)
  - [Contributing](#contributing)
  - [License](#license)

## About

A dynamic ERC721 NFT contract that generates on-chain mood-based SVG artwork. Each NFT owner can flip their token's mood between HAPPY and SAD states, dynamically updating the token URI with corresponding SVG images.

### Key Features

- **Dynamic SVG Rendering**: NFT images are generated as base64-encoded SVGs stored directly in token metadata
- **Mood States**: Each NFT has two mood states (HAPPY/SAD) that affect the displayed image
- **Owner-Controlled Mood Flipping**: Only token owners can change their NFT's mood
- **Max Supply Management**: Configurable maximum supply prevents unlimited minting
- **Secure Ownership**: Built on OpenZeppelin's battle-tested ERC721 implementation

**Tech Stack:**
- Solidity 0.8.19
- Foundry (Forge/Cast)
- OpenZeppelin Contracts (ERC721, Base64)
- DevOps Tools

### Architecture

```
                    ┌─────────────────────────────┐
                    │       NFT Owner (EOA)        │
                    └────────────┬──────────────────┘
                                 │
                    ┌────────────┴───────────────┐
                    │                            │
              mintNft()                   flipMood(tokenId)
                    │                            │
                    ▼                            ▼
    ┌──────────────────────────────────────────────────────┐
    │                 DynamicNft Contract                  │
    │                   (ERC721 Token)                     │
    │                                                      │
    │  ┌──────────────────┐      ┌────────────────────┐   │
    │  │  State Variables │      │    Key Functions   │   │
    │  ├──────────────────┤      ├────────────────────┤   │
    │  │ s_currentSupply  │      │ mintNft()          │   │
    │  │ i_maxSupply      │      │ flipMood()         │   │
    │  │ s_tokenIdToMood  │      │ tokenURI()         │   │
    │  │ happySvgImageUri │      │ getCurrentMood()   │   │
    │  │ sadSvgImageUri   │      │ getMoodImage()     │   │
    │  └──────────────────┘      └────────────────────┘   │
    │                                                      │
    │  ┌──────────────────────────────────────────────┐   │
    │  │      Mood State Transitions                  │   │
    │  │                                              │   │
    │  │  NFT Created ──→ HAPPY (default) ←─┐        │   │
    │  │                       ↕             │        │   │
    │  │                     SAD ────────────┘        │   │
    │  │                                              │   │
    │  │  (Only owner can flip between states)        │   │
    │  └──────────────────────────────────────────────┘   │
    │                                                      │
    └──────────────────────────────────────────────────────┘

**Data Flow:**
1. User calls `mintNft()` → Contract mints new NFT with HAPPY mood by default
2. User calls `flipMood(tokenId)` → Contract toggles mood between HAPPY/SAD
3. User calls `tokenURI(tokenId)` → Contract returns base64-encoded JSON metadata with corresponding SVG
4. Frontend decodes the metadata to display the appropriate image

**Repository Structure:**
```
erc721-dynamic-svg/
├── src/
│   └── DynamicNft.sol                    # ERC721 contract with mood-based SVG generation
├── script/
│   ├── DeployDynamicNft.s.sol            # Deployment script and SVG encoding utilities
│   ├── HelperConfig.s.sol                # Network configuration (commented out)
│   └── Interactions.s.sol                # Script for minting and flipping moods
├── test/
│   ├── DeployDynamicNftTest.t.sol        # Deployment and SVG encoding tests
│   ├── DynamicNftTest.t.sol              # Contract functionality tests
│   └── InteractionsTest.t.sol            # Integration tests (deprecated)
├── img/
│   ├── happy.svg                         # Happy mood SVG image
│   └── sad.svg                           # Sad mood SVG image
├── broadcast/                             # Transaction broadcasts (git-ignored)
├── cache/                                 # Build cache (git-ignored)
├── lib/                                   # Dependencies
│   ├── forge-std/                        # Foundry Standard Library
│   ├── foundry-devops/                   # Foundry DevOps tools
│   └── openzeppelin-contracts/           # OpenZeppelin contracts
├── foundry.toml                          # Foundry configuration
├── Makefile                              # Build and deployment automation
├── README.md                             # This file
└── .env.example                          # Environment variables template
```

## Getting Started

### Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - Verify installation: `git --version`
- [foundry](https://getfoundry.sh/)
  - Verify installation: `forge --version`

### Quickstart

```bash
git clone https://github.com/0xGearhart/erc721-dynamic-svg
cd erc721-dynamic-svg
make
```

### Environment Setup

1. **Copy the environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Configure your `.env` file:**
   ```bash
   SEPOLIA_RPC_URL=your_sepolia_rpc_url_here
   MAINNET_RPC_URL=your_mainnet_rpc_url_here
   ETHERSCAN_API_KEY=your_etherscan_api_key_here
   DEFAULT_KEY_ADDRESS=public_address_of_your_encrypted_private_key_here
   ```

3. **Get testnet ETH:**
   - Sepolia Faucet: [cloud.google.com/application/web3/faucet/ethereum/sepolia](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)

4. **Configure Makefile**
- Change account name in Makefile to the name of your desired encrypted key 
  - change "--account defaultKey" to "--account <YOUR_ENCRYPTED_KEY_NAME>"
  - check encrypted key names stored locally with:

```bash
cast wallet list
```
- **If no encrypted keys found**
  - Encrypt private key to be used securely within foundry:

```bash
cast wallet import <account_name> --interactive
```

**⚠️ Security Warning:**
- Never commit your `.env` file
- Never use your mainnet private key for testing
- Use a separate wallet with only testnet funds

## Usage

### Build

Compile the contracts:

```bash
forge build
```

### Testing

Run the test suite:

```bash
forge test
```

Run tests with verbosity:

```bash
forge test -vvv
```

Run specific test:

```bash
forge test --match-test testFunctionName
```

### Test Coverage

Generate coverage report:

```bash
forge coverage
```

Create test coverage report and save to .txt file:

```bash
make coverage-report
```

### Deploy Locally

Start a local Anvil node:

```bash
make anvil
```

Deploy to local node (in another terminal):

```bash
make deploy
```

### Interact with Contract

Mint and manage your NFTs using the provided scripts or cast commands.

**Using Scripts (Recommended for local testing):**

```bash
# Mint a new NFT
make mint-nft

# Flip the mood of an existing NFT (default: token ID 0)
make flip-nft
```

**Using Cast Commands:**

```bash
# Get the contract address (after deployment)
CONTRACT_ADDRESS=0x...

# Mint a new NFT
cast send $CONTRACT_ADDRESS "mintNft()" --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY

# Flip the mood of NFT with ID 1
cast send $CONTRACT_ADDRESS "flipMood(uint256)" 1 --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY

# Check current mood of NFT with ID 1 (0 = HAPPY, 1 = SAD)
cast call $CONTRACT_ADDRESS "getCurrentMood(uint256)" 1 --rpc-url http://localhost:8545

# Get metadata URI for NFT with ID 1
cast call $CONTRACT_ADDRESS "tokenURI(uint256)" 1 --rpc-url http://localhost:8545

# Check current NFT supply
cast call $CONTRACT_ADDRESS "getCurrentSupply()" --rpc-url http://localhost:8545

# Check max supply
cast call $CONTRACT_ADDRESS "getMaxSupply()" --rpc-url http://localhost:8545
```

## Deployment

### Deploy to Testnet

Deploy to Sepolia:

```bash
make deploy ARGS="--network sepolia"
```

Or using forge directly:

```bash
forge script script/DeployDynamicNft.s.sol:DeployDynamicNft \
  --rpc-url $SEPOLIA_RPC_URL \
  --account defaultKey \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  -vvvv
```

### Verify Contract

If automatic verification fails:

```bash
forge verify-contract <CONTRACT_ADDRESS> src/DynamicNft.sol:DynamicNft \
  --chain-id 11155111 \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

### Deployment Addresses

| Network | Contract Address | Explorer                                          |
| ------- | ---------------- | ------------------------------------------------- |
| Sepolia | `TBD`            | [View on Etherscan](https://sepolia.etherscan.io) |
| Mainnet | `TBD`            | [View on Etherscan](https://etherscan.io)         |

## Security

### Audit Status

⚠️ **This contract has not been audited.** Use at your own risk.

For production use, consider:
- Professional security audit
- Bug bounty program
- Gradual rollout with monitoring

### Access Control (Roles & Permissions)

The DynamicNft contract uses **owner-based access control** to manage NFT mood changes:

**Owner Permissions:**
- **`flipMood(uint256 tokenId)`**: Only the token owner can flip their NFT's mood state
  - Access check: `if (_ownerOf(tokenId) != msg.sender) revert DynamicNft__OnlyOwnerCanChangeMood(tokenId);`
  - Prevents unauthorized mood changes on NFTs owned by others

**Minting (Public):**
- **`mintNft()`**: Anyone can mint a new NFT (if max supply not exceeded)
  - No access control restrictions
  - Creates supply limit enforcement through `i_maxSupply`
  - Each newly minted NFT starts with HAPPY mood by default

### Known Limitations

- **Immutable SVG Images**: SVG image URIs cannot be updated after deployment; requires deploying a new contract
- **No Pause Mechanism**: Minting cannot be paused; no emergency stop functionality
- **No Supply Changes**: Maximum supply is immutable and set at deployment
- **Single Mood Toggle**: Moods are limited to HAPPY/SAD; no additional mood states
- **No Metadata Updates**: Token metadata is fully deterministic and cannot be customized per token (except mood)

**Centralization Risks:**
- No centralized owner control; contract is fully decentralized once deployed
- SVG image URIs are hardcoded and cannot be changed, ensuring deterministic behavior

## Gas Optimization

**Gas Optimization Techniques:**
- **Immutable Variables**: `i_maxSupply` and SVG URIs stored as immutable, reducing storage reads
- **Efficient State Management**: Single mapping for mood tracking (`s_tokenIdToMood`)
- **No Complex Loops**: Linear operations only; no nested loops or complex iterations
- **Minimal Storage**: Only essential state variables stored on-chain
- **Base64 Encoding**: Performed via external OpenZeppelin library, optimized for gas

Generate gas report and save to .txt file:

```bash
make gas-report
```

Generate gas snapshot:

```bash
forge snapshot
```

Compare gas changes:

```bash
forge snapshot --diff
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Disclaimer:** This software is provided "as is", without warranty of any kind. Use at your own risk.

**Built with [Foundry](https://getfoundry.sh/)**