# Coin Sack NFT Minting

This repository contains source code for the Coin Sack BEP721 token and factory smart contracts; a component of the Coin Sack NFT marketplace. 
___

## How It Works

This smart contract system allows NFT marketplace users to pay minting fees with Coin Sack tokens or BNB. When fees are paid with CS, tokens are transfered to the `DeadAddress`, passing them on to its built-in recycling method ([see the CS token on GitHub](https://github.com/Coin-Sack/Coin_Sack_Token)). BNB used to pay fees is swapped through PancakeSwap to CS so that the same transfer to the `DeadAddress` can be made. BNB minting fees are calculated at runtime to be `1.15 X current swap rate` thus ensuring an appropriate ammount of CS tokens are spent for the mint.

___

## The Coin Sack Project
Coin Sack was created with the belief that there need to be stronger, more trustworthy, and more worthwhile projects built throughout the deFi space. We decided to take this into our own hands by launching Coin Sack; a BEP-20 token featuring battle tested tokenomics, an innovative future roadmap, and a trustworthy team that cares for its investors.

Check out the Coin Sack project online at [Coin-Sack.com](https://coin-sack.com/)!