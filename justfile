export RUST_BACKTRACE := "full"
export RUST_LOG := "info"
export ETH_WALLET_PRIVATE_KEY := "<insert yuor private key here>"
export BONSAI_API_KEY := "<insert your bonsai api key>"
export BONSAI_API_URL := "https://api.bonsai.xyz/"

chain-id := "31337"

contract := `jq -re '.transactions[] | select(.contractName == "EvenNumber") | .contractAddress' ./broadcast/Deploy.s.sol/31337/run-latest.json`

build:
    cargo build --release

contract:
    echo {{contract}}

contract-call:
    cast call --rpc-url http://localhost:8545 {{contract}} 'get()(uint256)'

deploy:
    forge script --rpc-url http://localhost:8545 --broadcast script/Deploy.s.sol

publish value='12345678' prover='local':
    cargo run --bin publisher -- --chain-id={{chain-id}} --rpc-url=http://localhost:8545 --contract={{contract}} --input={{value}} --prover={{prover}}

publish-jwt value='123456789' prover='local':
    cargo run --bin publisher -- --chain-id={{chain-id}} --rpc-url=http://localhost:8545 --contract={{contract}} --input={{value}} --method=jwt --prover={{prover}}

publish-jwt-cuda value='123456789' prover='local':
    cargo run --bin publisher --features=cuda -- --chain-id={{chain-id}} --rpc-url=http://localhost:8545 --contract={{contract}} --input={{value}} --method=jwt --prover={{prover}}

publish-jwt-metal value='123456789' prover='local':
    cargo run --bin publisher --features=metal -- --chain-id={{chain-id}} --rpc-url=http://localhost:8545 --contract={{contract}} --input={{value}} --method=jwt --prover={{prover}}
