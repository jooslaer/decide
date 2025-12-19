# Decide

Decision-making platform with encrypted votes and private proposals

## So what's this about?

Privacy is important, but most systems need to decrypt your data to do anything useful with it. That kind of defeats the purpose, doesn't it?

This project uses Zama FHEVM to actually keep things private. The data stays encrypted even when the system is processing it. Neat, huh?

## Setup

Install dependencies:

`ash
npm install
`

Compile the contracts:

`ash
npm run compile
`

You'll need a .env file - check env.template to see what goes in there.

Deploy:

`ash
npm run deploy:sepolia
`

## Contracts

- `DecisionPlatform`

Addresses end up in contracts.json after you deploy.

## The tech

- Zama FHEVM for the encryption magic
- Hardhat for development
- Solidity for the contracts
- TypeScript because we like types

Everything's on Sepolia testnet, so you'll need testnet ETH.

## How it works

Your data gets encrypted before it goes on-chain. The contract can do operations on it while it's still encrypted. Only you can decide when to decrypt, and even then it's only for specific things you authorize.

## Contributing

Feel free to fork and play around. If you find issues or have ideas, open an issue or send a pull request.

## License

MIT


