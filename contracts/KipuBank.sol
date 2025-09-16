/**
 *Submitted for verification at Etherscan.io on 2025-09-16
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KipuBank {
    
    /// @notice Maximum amount that can be withdrawn per transaction
    /// @dev Set at deployment, immutable for security
    uint256 public immutable withdrawalLimit;
    
    /// @notice Minimum deposit amount to prevent spam
    /// @dev Constant value of 0.001 ETH
    uint256 public constant MIN_DEPOSIT = 0.001 ether;
    
    /// @notice Global cap for total ETH under custody
    /// @dev Set at deployment, prevents unlimited deposits
    uint256 public bankCap;
    
    /// @notice Total amount currently deposited in the bank
    /// @dev Increases on deposits, decreases on withdrawals
    uint256 public totalDeposited;
    
    /// @notice Total number of deposits made
    /// @dev Incremented on each successful deposit
    uint256 public depositCount;
    
    /// @notice Total number of withdrawals made
    /// @dev Incremented on each successful withdrawal
    uint256 public withdrawalCount;
    
    /// @notice Maps user address to their vault balance
    /// @dev Updated on deposits and withdrawals
    mapping(address => uint256) public userBalances;
    
    // === CUSTOM ERRORS ===
    
    /// @notice Reverted when user tries to withdraw more than their balance
    /// @dev Thrown when amount > userBalances[msg.sender]
    error InsufficientBalance();
    
    /// @notice Reverted when withdrawal amount exceeds per-transaction limit
    /// @dev Thrown when amount > withdrawalLimit
    error ExceedsWithdrawalLimit();
    
    /// @notice Reverted when deposit would exceed global bank capacity
    /// @dev Thrown when totalDeposited + msg.value > bankCap
    error BankCapExceeded();
    
    /// @notice Reverted when ETH transfer fails
    /// @dev Thrown when low-level call returns false
    error TransferFailed();
    
    /// @notice Reverted when deposit amount is below minimum
    /// @dev Thrown when msg.value < MIN_DEPOSIT
    error DepositTooSmall();
    
    /// @notice Reverted when reentrancy is detected
    /// @dev Thrown when locked == true in nonReentrant modifier
    error Reentrancy();
    
    /// @notice Reverted when amount is zero
    /// @dev Thrown when amount == 0 in deposit or withdrawal operations
    error ZeroAmount();
    
    // === EVENTS ===
    
    /**
     * @dev Emitted when user makes a deposit
     * @param user Address that made the deposit
     * @param amount Amount deposited in wei
     * @param newBalance User's new vault balance
     */
    event DepositMade(address indexed user, uint256 amount, uint256 newBalance);
    
    /**
     * @dev Emitted when user makes a withdrawal
     * @param user Address that made the withdrawal
     * @param amount Amount withdrawn in wei
     * @param newBalance User's new vault balance
     */
    event WithdrawalMade(address indexed user, uint256 amount, uint256 newBalance);
    
    // === MODIFIER ===
    
    /// @notice State variable to track reentrancy protection
    /// @dev Set to true during function execution to prevent reentrancy
    bool private locked;
    
    /// @notice Prevents reentrancy attacks
    /// @dev Sets locked to true during execution, reverts if already locked
    modifier nonReentrant() {
        if (locked) revert Reentrancy();
        locked = true;
        _;
        locked = false;
    }
        
    /**
     * @dev Initializes the KipuBank with bank capacity and withdrawal limit
     * @param _bankCap Maximum total amount that can be deposited
     * @param _withdrawalLimit Maximum amount per withdrawal transaction
     */
    constructor(uint256 _bankCap, uint256 _withdrawalLimit) {
        bankCap = _bankCap;
        withdrawalLimit = _withdrawalLimit;
    }
    
    /**
     * @dev Allows users to deposit ETH into their personal vault
     * @notice Respects minimum deposit and global bank capacity
     */
    function deposit() external payable {
        _validateDeposit(msg.value);
        
        if (msg.value < MIN_DEPOSIT) {
            revert DepositTooSmall();
        }
        
        if (totalDeposited + msg.value > bankCap) {
            revert BankCapExceeded();
        }
        
        userBalances[msg.sender] += msg.value;
        depositCount++;
        totalDeposited += msg.value;
        
        emit DepositMade(msg.sender, msg.value, userBalances[msg.sender]);
    }
        
    /**
     * @dev Allows users to withdraw ETH from their vault
     * @param amount Amount to withdraw in wei
     * @notice Respects per-transaction withdrawal limit
     */
    function withdraw(uint256 amount) external nonReentrant {
        if (amount == 0) {
            revert ZeroAmount();
        }
        
        if (amount > withdrawalLimit) {
            revert ExceedsWithdrawalLimit();
        }
        
        if (amount > userBalances[msg.sender]) {
            revert InsufficientBalance();
        }
        
        userBalances[msg.sender] -= amount;
        withdrawalCount++;
        totalDeposited -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }
        
        emit WithdrawalMade(msg.sender, amount, userBalances[msg.sender]);
    }
    
    /// @notice Returns the vault balance of a specific user
    function getUserBalance(address user) external view returns (uint256) {
        return userBalances[user];
    }
    
    /// @notice Returns bank totals and statistics
    function getBankInfo() external view returns (
        uint256 _bankCap,
        uint256 _totalDeposited,
        uint256 _depositCount,
        uint256 _withdrawalCount
    ) {
        return (bankCap, totalDeposited, depositCount, withdrawalCount);
    }
    
    /**
     * @dev Internal validation for deposit operations
     * @param amount Amount being deposited
     */
    function _validateDeposit(uint256 amount) private pure {
        if (amount == 0) revert ZeroAmount();
    }
    
    /// @notice Rejects direct ETH transfers to force use of deposit()
    /// @dev Reverts to prevent ETH being sent without updating userBalances
    receive() external payable {
        revert ZeroAmount();
    }
    
    /// @notice Rejects calls to non-existent functions
    /// @dev Prevents accidental ETH loss from wrong function calls
    fallback() external payable {
        revert ZeroAmount();
    }
}