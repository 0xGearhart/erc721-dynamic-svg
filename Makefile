-include .env

.PHONY: all test clean remove update test build deploy fund install snapshot format anvil mint-nft flip-nft

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: clean remove install build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# Install dependencies
install :; forge install cyfrin/foundry-devops@0.4.0 && forge install foundry-rs/forge-std@v1.8.2 && forge install openzeppelin/openzeppelin-contracts@v5.4.0

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

# Create test coverage report and save to .txt file
coverage-report :; FOUNDRY_PROFILE=coverage forge coverage --report debug > coverage.txt

# Generate Gas Snapshot
snapshot :; forge snapshot

# Generate table showing gas cost for each function
gas-report :; forge test --gas-report > gas.txt

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account defaultKey --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script script/DeployDynamicNft.s.sol:DeployDynamicNft $(NETWORK_ARGS)

mint-nft:
	@forge script script/Interactions.s.sol:MintDynamicNft $(NETWORK_ARGS)

flip-nft:
	@forge script script/Interactions.s.sol:FlipDynamicNft $(NETWORK_ARGS)
