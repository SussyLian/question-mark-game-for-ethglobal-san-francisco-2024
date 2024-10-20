# Step 1: Set the RPC URL of your custom chain
export RPC_URL="https://testnet.skalenodes.com/v1/lanky-ill-funny-testnet"

# Step 2: Set the private key (you should replace this with your actual private key)
export PRIVATE_KEY="your_private_key"

# Step 3: Deploy the contract using Foundry (forge)
forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY path/to/YourContract.sol:YourContract
