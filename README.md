# KipuBank - Secure ETH Vault System

## Project Description

**KipuBank** is a secure smart contract implementing a personal bank system for ETH deposits and withdrawals. It provides users with individual vaults while maintaining global deposit limits and per-transaction withdrawal restrictions.

## Main Features

### Core Functionality
- **ETH Vaults**: Each user has an individual vault for secure ETH storage
- **Controlled Deposits**: Minimum deposit requirement (0.001 ETH) with global capacity limits
- **Limited Withdrawals**: Per-transaction withdrawal limits set at deployment
- **Global Bank Cap**: Maximum total ETH under custody to prevent unlimited exposure
- **Transaction Tracking**: Complete logging of deposits and withdrawals with counters

### Security Features
- **Reentrancy Protection**: `nonReentrant` modifier prevents reentrancy attacks
- **Custom Error Handling**: Gas-efficient custom errors instead of require messages
- **CEI Pattern**: Checks-Effects-Interactions pattern implementation
- **Direct Transfer Prevention**: `receive()` and `fallback()` functions reject direct ETH transfers
- **Immutable Security**: Critical parameters set at deployment and cannot be changed

### Technical Implementation
- **Complete NatSpec Documentation**: Every function, variable, and error documented
- **Event Emission**: All operations emit detailed events for transparency
- **Gas Optimization**: Efficient storage patterns and error handling
- **Clean Architecture**: Well-organized code structure with clear naming conventions

### Contract Components

#### **Immutable/Constant Variables**
- `withdrawalLimit`: Maximum amount per withdrawal transaction (set at deployment)
- `MIN_DEPOSIT`: Constant minimum deposit amount (0.001 ETH)

#### **Storage Variables**
- `bankCap`: Global maximum ETH under custody
- `totalDeposited`: Current total ETH in the bank
- `depositCount`: Total number of deposits made
- `withdrawalCount`: Total number of withdrawals made

#### **Mappings**
- `userBalances`: Maps user addresses to their vault balances

#### **Custom Errors**
- `InsufficientBalance()`: Withdrawal exceeds user balance
- `ExceedsWithdrawalLimit()`: Withdrawal exceeds per-transaction limit
- `BankCapExceeded()`: Deposit would exceed global capacity
- `TransferFailed()`: ETH transfer failed
- `DepositTooSmall()`: Deposit below minimum
- `Reentrancy()`: Reentrancy attack detected
- `ZeroAmount()`: Zero amount provided

#### **Events**
- `DepositMade`: Emitted on successful deposits
- `WithdrawalMade`: Emitted on successful withdrawals

#### **Functions**
- `deposit()`: External payable function for deposits
- `withdraw(uint256)`: External function for withdrawals with reentrancy protection
- `getUserBalance(address)`: External view function for balance queries
- `getBankInfo()`: External view function for bank statistics
- `_validateDeposit(uint256)`: Private validation function

## Prerequisites

- **MetaMask** wallet extension
- **Testnet ETH** 
- **Remix IDE**

## Deployment Instructions

#### Step 1: Setup
1. Open [Remix IDE](https://remix.ethereum.org)
2. Create new file: `contracts/KipuBank.sol`
3. Copy the contract code from this repository

#### Step 2: Compilation
1. Go to **Solidity Compiler** tab
2. Set compiler version to `^0.8.19`
3. Compile **KipuBank.sol**

#### Step 3: Deployment
1. Go to **Deploy & Run Transactions** tab
2. Select **Injected Provider - MetaMask** as environment
3. Connect to your preferred testnet (Sepolia recommended)
4. Set deployment parameters:
5. Click **Deploy**
6. Confirm transaction in MetaMask

#### Step 4: Verification
1. Copy deployed contract address
2. Go to testnet explorer (e.g., [Sepolia Etherscan](https://sepolia.etherscan.io))
3. Search for your contract address
4. Click **Verify and Publish** 
5. Upload contract source code

## How to Interact with the Contract

### Making a Deposit
1. In Remix, go to **Deploy & Run Transactions**
2. Find your deployed contract
3. Set **VALUE** field to desired amount (e.g., `0.001` Ether)
4. Click **deposit** button
5. Confirm transaction in MetaMask

### Making a Withdrawal
1. In the contract interface, find **withdraw** function
2. Enter amount in wei (e.g., `100000000000000000` for 0.1 ETH)
3. Click **withdraw**
4. Confirm transaction in MetaMask

### Checking Balances
1. Click **userBalances** with your address as parameter
2. Or use **getUserBalance** function
3. View returns in wei (divide by 10^18 for ETH)

### Getting Bank Information
1. Click **getBankInfo** to see:
   - Bank capacity
   - Total deposited
   - Number of deposits/withdrawals

## Contract Deployment Parameters

### My Values for Testnet Deployment
```
bankCap: 5000000000000000000 (5 ETH)
withdrawalLimit: 500000000000000000 (0.5 ETH)
```

## Security Considerations

### Implemented Security Measures
- Reentrancy protection via `nonReentrant` modifier
- Custom errors for gas efficiency
- Checks-Effects-Interactions pattern
- Direct transfer prevention
- Input validation on all functions

### Important Notes
- Contract is **immutable** after deployment
- Withdrawal limits are **permanent** and cannot be changed
- Bank capacity is **fixed** at deployment
- All ETH transfers use low-level calls for security

## Deployed Contract

**Sepolia Testnet**: `0x32bb9546ceC0092147d7E901Fc220272B268824f`

View on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x32bb9546ceC0092147d7E901Fc220272B268824f)

---
