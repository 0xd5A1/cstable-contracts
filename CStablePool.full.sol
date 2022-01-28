// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/lib/TransferHelper.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

// helper mBNBods for interacting with BEP20 tokens and sending BNB that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }
}

// File: contracts/CStablePool.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;







contract CStablePool is ERC20, Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    uint256 private FEE_DENOMINATOR = 10**10;
    uint256 private LENDING_PRECISION = 10**18;
    uint256 private PRECISION = 10**18; // The precision to convert to
    uint256[] private PRECISION_MUL = [1, 1, 1];
    uint256[] private RATES = [
        1000000000000000000,
        1000000000000000000,
        1000000000000000000
    ];
    uint256 private FEE_INDEX = 2; // Which coin may potentially have fees (USDT)

    uint256 private MAX_ADMIN_FEE = 10 * 10**9;
    uint256 private MAX_FEE = 5 * 10**9;
    uint256 private MAX_A = 10**6;
    uint256 private MAX_A_CHANGE = 10;

    uint256 private ADMIN_ACTIONS_DELAY = 3 * 86400;
    uint256 private MIN_RAMP_TIME = 86400;

    address[] public coins;
    uint256[] public balances;
    uint256 public fee; // fee * 1e10
    uint256 public admin_fee; // admin_fee * 1e10

    uint256 public initial_A;
    uint256 public future_A;
    uint256 public initial_A_time;
    uint256 public future_A_time;

    uint256 public admin_actions_deadline;
    uint256 public transfer_ownership_deadline;
    uint256 public future_fee;
    uint256 public future_admin_fee;
    address public future_owner;

    bool public is_killed;
    uint256 public kill_deadline;
    uint256 private KILL_DEADLINE_DT = 2 * 30 * 86400;

    uint256 public volume;

    // Events
    event TokenExchange(
        address buyer,
        uint256 sold_id,
        uint256 tokens_sold,
        uint256 bought_id,
        uint256 tokens_bought
    );

    event AddLiquidity(
        address provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 invariant,
        uint256 token_supply
    );

    event RemoveLiquidity(
        address provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 token_supply
    );

    event RemoveLiquidityOne(
        address provider,
        uint256 token_amount,
        uint256 coin_amount
    );

    event RemoveLiquidityImbalance(
        address provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 invariant,
        uint256 token_supply
    );

    event CommitNewAdmin(uint256 deadline, address admin);

    event NewAdmin(address admin);

    event CommitNewFee(uint256 deadline, uint256 fee, uint256 admin_fee);

    event NewFee(uint256 fee, uint256 admin_fee);

    event RampA(
        uint256 old_A,
        uint256 new_A,
        uint256 initial_time,
        uint256 future_time
    );

    event StopRampA(uint256 A, uint256 t);
    event UnkillMe();
    event KillMe();
    event DonateAdminFees();
    event WithdrawAdminFees();
    event RevertTransferOwnership();
    event RevertNewParameters();

    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _coins,
        uint256 _a,
        uint256 _fee,
        uint256 _admin_fee,
        address ownerAddress
    )  ERC20(_name, _symbol) {
        transferOwnership(ownerAddress);
        for (uint256 i = 0; i < _coins.length; i++) {
            require(_coins[i] != address(0), "BNB is not support.");
        }
        coins = _coins;
        initial_A = _a;
        future_A = _a;
        fee = _fee;
        admin_fee = _admin_fee;
        kill_deadline = block.timestamp.add(KILL_DEADLINE_DT);
        balances = new uint256[](coins.length);
        for (uint256 i = 0; i < coins.length; i++) {
            balances[i] = 0;
        }
    }

    function _A() internal view returns (uint256 A1) {
        // Handle ramping A up or down
        uint256 t1 = future_A_time;
        A1 = future_A;
        if (block.timestamp < t1) {
            uint256 A0 = initial_A;
            uint256 t0 = initial_A_time;
            // Expressions in uint256 cannot have negative numbers, thus "if"
            if (A1 > A0) {
                // return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
                A1 = A0.add(
                    A1.sub(A0).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
                );
            } else {
                // return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
                A1 = A0.sub(
                    A0.sub(A1).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
                );
            }
        } else {
            //if (t1 == 0 || block.timestamp >= t1)
            // retrun A1
        }
    }

    // overide

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {}

    function A() external view returns (uint256 A1) {
        A1 = _A();
    }

    function _xp() internal view returns (uint256[] memory result) {
        result = RATES;
        for (uint256 i = 0; i < coins.length; i++) {
            // result[i] = result[i] * self.balances[i] / LENDING_PRECISION
            result[i] = result[i].mul(balances[i]).div(LENDING_PRECISION);
        }
    }

    function _xp_mem(uint256[] memory _balances)
        internal
        view
        returns (uint256[] memory result)
    {
        result = RATES;
        for (uint256 i = 0; i < coins.length; i++) {
            // result[i] = result[i] * _balances[i] / PRECISION
            result[i] = result[i].mul(_balances[i]).div(PRECISION);
        }
    }

    function get_D(uint256[] memory xp, uint256 amp)
        internal
        view
        returns (uint256 D)
    {
        uint256 S = 0;
        for (uint256 i = 0; i < xp.length; i++) {
            uint256 _x = xp[i];
            // S += _x
            S = S.add(_x);
        }
        if (S == 0) {
            D = 0;
        }
        uint256 Dprev = 0;
        D = S;
        // Ann: uint256 = amp * coins.length
        uint256 Ann = amp.mul(coins.length);
        for (uint256 i = 0; i < 255; i++) {
            uint256 D_P = D;
            for (uint256 j = 0; j < xp.length; j++) {
                uint256 _x = xp[j];
                // D_P = D_P * D / (_x * coins.length)
                D_P = D_P.mul(D).div(_x.mul(uint256(coins.length))); // If division by 0, this will be borked: only withdrawal will work. And that is good
            }
            Dprev = D;
            // D = (Ann * S + D_P * coins.length) * D / ((Ann - 1) * D + (coins.length + 1) * D_P)
            uint256 numerator =
                Ann.mul(S).add(D_P.mul(uint256(coins.length))).mul(D);
            uint256 denominator =
                Ann.sub(uint256(1)).mul(D).add(
                    uint256(coins.length).add(uint256(1)).mul(D_P)
                );
            D = numerator.div(denominator);
            // Equality with the precision of 1
            if (D > Dprev) {
                if (D.sub(Dprev) <= 1) {
                    break;
                }
            } else {
                if (Dprev.sub(D) <= 1) {
                    break;
                }
            }
        }
    }

    function get_D_mem(uint256[] memory _balances, uint256 amp)
        internal
        view
        returns (uint256 D)
    {
        D = get_D(_xp_mem(_balances), amp);
    }

    function get_virtual_price() external view returns (uint256 price) {
        // Returns portfolio virtual price (for calculating profit)
        // scaled up by 1e18
        uint256 D = get_D(_xp(), _A());
        // # D is in the units similar to DAI (e.g. converted to precision 1e18)
        // # When balanced, D = n * x_u - total virtual value of the portfolio
        uint256 token_supply = totalSupply();
        // return D * PRECISION / token_supply
        price = D.mul(PRECISION).div(token_supply);
    }

    function calc_token_amount(uint256[] calldata amounts, bool deposit)
        external
        view
        returns (uint256 result)
    {
        // Simplified method to calculate addition or reduction in token supply at
        //     deposit or withdrawal without taking fees into account (but looking at
        //     slippage).
        //     Needed to prevent front-running, not for precise calculations!
        uint256[] memory _balances = balances;
        uint256 amp = _A();
        uint256 D0 = get_D_mem(_balances, amp);
        for (uint256 i = 0; i < coins.length; i++) {
            if (deposit) {
                // _balances[i] += amounts[i]
                _balances[i] = _balances[i].add(amounts[i]);
            } else {
                // _balances[i] -= amounts[i]
                _balances[i] = _balances[i].sub(amounts[i]);
            }
        }
        uint256 D1 = get_D_mem(_balances, amp);
        uint256 token_amount = totalSupply();
        uint256 diff = 0;
        if (deposit) {
            // diff = D1 - D0
            diff = D1.sub(D0);
        } else {
            diff = D0.sub(D1);
        }
        // return diff * token_amount / D0
        result = diff.mul(token_amount).div(D0);
    }

    function add_liquidity(uint256[] calldata amounts, uint256 min_mint_amount)
        external
        nonReentrant
    {
        require(!is_killed, "is killed");
        uint256[] memory fees = new uint256[](coins.length);
        // _fee: uint256 = self.fee * coins.length / (4 * (coins.length - 1))
        uint256 _fee =
            fee.mul(coins.length).div(
                uint256(4).mul(uint256(coins.length).sub(uint256(1)))
            );
        uint256 amp = _A();

        // # Initial invariant
        uint256 D0 = 0;
        uint256[] memory old_balances = balances;
        if (totalSupply() > 0) {
            D0 = get_D_mem(old_balances, amp);
        }
        uint256[] memory new_balances = old_balances;
        for (uint256 i = 0; i < coins.length; i++) {
            uint256 in_amount = amounts[i];
            if (totalSupply() == 0) {
                require(in_amount > 0, "initial deposit requires all coins"); // # dev: initial deposit requires all coins
            }
            address in_coin = coins[i];
            if (in_amount > 0) {
                // # Take coins from the sender
                if (i == FEE_INDEX) {
                    in_amount = IERC20(in_coin).balanceOf(address(this));
                }
                TransferHelper.safeTransferFrom(
                    in_coin,
                    msg.sender,
                    address(this),
                    amounts[i]
                );
                if (i == FEE_INDEX) {
                    // in_amount = ERC20(in_coin).balanceOf(self) - in_amount
                    in_amount = IERC20(in_coin).balanceOf(address(this)).sub(
                        in_amount
                    );
                }
            }
            // new_balances[i] = old_balances[i] + in_amount
            new_balances[i] = old_balances[i].add(in_amount);
        }
        // # Invariant after change
        uint256 D1 = get_D_mem(new_balances, amp);
        require(D1 > D0, "D1 must bigger than D0");

        // # We need to recalculate the invariant accounting for fees
        // # to calculate fair user's share
        uint256 D2 = D1;
        if (totalSupply() > 0) {
            for (uint256 i = 0; i < coins.length; i++) {
                // ideal_balance: uint256 = D1 * old_balances[i] / D0
                uint256 ideal_balance = D1.mul(old_balances[i]).div(D0);
                uint256 difference = 0;
                if (ideal_balance > new_balances[i]) {
                    // difference = ideal_balance - new_balances[i]
                    difference = ideal_balance.sub(new_balances[i]);
                } else {
                    // difference = new_balances[i] - ideal_balance
                    difference = new_balances[i].sub(ideal_balance);
                }
                // fees[i] = _fee * difference / FEE_DENOMINATOR
                fees[i] = _fee.mul(difference).div(FEE_DENOMINATOR);
                // self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
                balances[i] = new_balances[i].sub(
                    fees[i].mul(admin_fee).div(FEE_DENOMINATOR)
                );
                // new_balances[i] -= fees[i]
                new_balances[i] = new_balances[i].sub(fees[i]);
            }
            D2 = get_D_mem(new_balances, amp);
        } else {
            balances = new_balances;
        }
        // # Calculate, how much pool tokens to mint
        uint256 mint_amount = 0;
        if (totalSupply() == 0) {
            mint_amount = D1; //# Take the dust if there was any
        } else {
            // mint_amount = token_supply * (D2 - D0) / D0
            mint_amount = totalSupply().mul(D2.sub(D0)).div(D0);
        }

        require(mint_amount >= min_mint_amount, "Slippage screwed you");

        // # Mint pool tokens
        _mint(msg.sender, mint_amount);

        emit AddLiquidity(
            msg.sender,
            amounts,
            fees,
            D1,
            totalSupply().add(mint_amount)
        );
    }

    function get_y(
        uint256 i,
        uint256 j,
        uint256 x,
        uint256[] memory xp_
    ) internal view returns (uint256 y) {
        // # x in the input is converted to the same price/precision
        require(i != j, "dev: same coin");
        require(j >= 0, "dev: j below zero");
        require(j < coins.length, "dev: j above coins.length");

        // # should be unreachable, but good for safety
        require(i >= 0, "i must >= 0");
        require(i < coins.length, "i must < n_coins");
        uint256 amp = _A();
        uint256 D = get_D(xp_, amp);
        uint256 c = D;
        uint256 S_ = 0;
        // Ann: uint256 = amp * coins.length
        uint256 Ann = amp.mul(uint256(coins.length));

        uint256 _x = 0;
        for (uint256 _i = 0; _i < coins.length; _i++) {
            if (_i == i) {
                _x = x;
            } else if (_i != j) {
                _x = xp_[_i];
            } else {
                continue;
            }
            // S_ += _x
            S_ = S_.add(_x);
            // c = c * D / (_x * coins.length)
            c = c.mul(D).div(_x.mul(uint256(coins.length)));
        }
        // c = c * D / (Ann * coins.length)
        c = c.mul(D).div(Ann.mul(coins.length));
        // uint256 b = S_.add(D.div(Ann)); //# - D
        uint256 y_prev = 0;
        y = D;
        for (uint256 _i = 0; _i < 255; _i++) {
            y_prev = y;
            // b: uint256 = S_ + D / Ann  # - D
            // y = (y*y + c) / (2 * y + b - D)
            y = y.mul(y).add(c).div(
                y.mul(uint256(2)).add(S_.add(D.div(Ann))).sub(D)
            );
            // # Equality with the precision of 1
            if (y > y_prev) {
                if (y.sub(y_prev) <= 1) {
                    break;
                }
            } else {
                if (y_prev.sub(y) <= 1) {
                    break;
                }
            }
        }
    }

    function get_dy(
        uint256 i,
        uint256 j,
        uint256 dx
    ) external view returns (uint256 result) {
        // # dx and dy in c-units
        uint256[] memory xp = _xp();

        // x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
        uint256 x = xp[i].add(dx.mul(RATES[i]).div(PRECISION));
        uint256 y = get_y(i, j, x, xp);
        // dy: uint256 = (xp[j] - y - 1) * PRECISION / rates[j]
        uint256 dy = xp[j].sub(y).sub(1).mul(PRECISION).div(RATES[j]);
        // _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
        uint256 _fee = fee.mul(dy).div(FEE_DENOMINATOR);
        result = dy.sub(_fee);
    }

    function get_dy_underlying(
        uint256 i,
        uint256 j,
        uint256 dx
    ) external view returns (uint256 result) {
        //# dx and dy in underlying units
        uint256[] memory xp = _xp();
        uint256[] memory precisions = PRECISION_MUL;

        // x: uint256 = xp[i] + dx * precisions[i]
        uint256 x = xp[i].add(dx.mul(precisions[i]));
        uint256 y = get_y(i, j, x, xp);
        // dy: uint256 = (xp[j] - y - 1) / precisions[j]
        uint256 dy = xp[j].sub(y).sub(uint256(1)).div(precisions[j]);
        // _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
        uint256 _fee = fee.mul(dy).div(FEE_DENOMINATOR);
        // return dy - _fee
        result = dy.sub(_fee);
    }

    function exchange(
        uint256 i,
        uint256 j,
        uint256 dx,
        uint256 min_dy
    ) external nonReentrant {
        require(!is_killed, "dev: is killed");

        uint256[] memory xp = _xp_mem(balances);

        // # Handling an unexpected charge of a fee on transfer (USDT, PAXG)
        uint256 dx_w_fee = dx;
        address input_coin = coins[i];
        if (i == FEE_INDEX) {
            dx_w_fee = IERC20(input_coin).balanceOf(address(this));
        }
        // # "safeTransferFrom" which works for ERC20s which return bool or not
        TransferHelper.safeTransferFrom(
            input_coin,
            msg.sender,
            address(this),
            dx
        );
        if (i == FEE_INDEX) {
            // dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee
            dx_w_fee = IERC20(input_coin).balanceOf(address(this)).sub(
                dx_w_fee
            );
        }
        // x: uint256 = xp[i] + dx_w_fee * rates[i] / PRECISION
        uint256 x = xp[i].add(dx_w_fee.mul(RATES[i]).div(PRECISION));
        uint256 y = get_y(i, j, x, xp);

        // dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
        uint256 dy = xp[j].sub(y).sub(uint256(1)); // # -1 just in case there were some rounding errors
        // dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
        uint256 dy_fee = dy.mul(fee).div(FEE_DENOMINATOR);

        // # Convert all to real units
        // dy = (dy - dy_fee) * PRECISION / rates[j]
        dy = dy.sub(dy_fee).mul(PRECISION).div(RATES[j]);
        require(dy >= min_dy, "Exchange resulted in fewer coins than expected");

        // dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
        uint256 dy_admin_fee = dy_fee.mul(admin_fee).div(FEE_DENOMINATOR);
        // dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
        dy_admin_fee = dy_admin_fee.mul(PRECISION).div(RATES[j]);

        // # Change balances exactly in same way as we change actual ERC20 coin amounts
        // self.balances[i] = old_balances[i] + dx_w_fee
        balances[i] = balances[i].add(dx_w_fee);
        // # When rounding errors happen, we undercharge admin fee in favor of LP
        // self.balances[j] = old_balances[j] - dy - dy_admin_fee
        balances[j] = balances[j].sub(dy).sub(dy_admin_fee);
        TransferHelper.safeTransfer(coins[j], msg.sender, dy);
        volume = volume.add(dx);
        emit TokenExchange(msg.sender, i, dx, j, dy);
    }

    function remove_liquidity(uint256 _amount, uint256[] calldata min_amounts)
        external
        nonReentrant
    {
        uint256 total_supply = totalSupply();
        uint256[] memory amounts = new uint256[](coins.length);
        uint256[] memory fees = new uint256[](coins.length); //  # Fees are unused but we've got them historically in event
        for (uint256 i = 0; i < coins.length; i++) {
            // value: uint256 = self.balances[i] * _amount / total_supply
            uint256 value = balances[i].mul(_amount).div(total_supply);
            require(
                value >= min_amounts[i],
                "Withdrawal resulted in fewer coins than expected"
            );
            // self.balances[i] -= value
            balances[i] = balances[i].sub(value);
            amounts[i] = value;
            TransferHelper.safeTransfer(coins[i], msg.sender, value);
        }
        _burn(msg.sender, _amount); // # dev: insufficient funds

        emit RemoveLiquidity(
            msg.sender,
            amounts,
            fees,
            total_supply.sub(_amount)
        );
    }

    function remove_liquidity_imbalance(
        uint256[] calldata amounts,
        uint256 max_burn_amount
    ) external nonReentrant {
        require(!is_killed, "is killed"); //not self.  # dev: is killed

        require(totalSupply() != 0, "  # dev: zero total supply");
        // _fee: uint256 = self.fee * coins.length / (4 * (coins.length - 1))
        uint256 _fee = fee.mul(coins.length).div(coins.length.sub(1).mul(4));
        // uint256 _admin_fee = admin_fee;
        uint256 amp = _A();

        uint256[] memory old_balances = balances;
        uint256[] memory new_balances = old_balances;
        uint256 D0 = get_D_mem(old_balances, amp);
        for (uint256 i = 0; i < coins.length; i++) {
            // new_balances[i] -= amounts[i]
            new_balances[i] = new_balances[i].sub(amounts[i]);
        }
        uint256 D1 = get_D_mem(new_balances, amp);
        uint256[] memory fees = new uint256[](coins.length);
        for (uint256 i = 0; i < coins.length; i++) {
            // ideal_balance: uint256 = D1 * old_balances[i] / D0
            uint256 ideal_balance = D1.mul(old_balances[i]).div(D0);
            uint256 difference = 0;
            if (ideal_balance > new_balances[i]) {
                // difference = ideal_balance - new_balances[i]
                difference = ideal_balance.sub(new_balances[i]);
            } else {
                // difference = new_balances[i] - ideal_balance
                difference = new_balances[i].sub(ideal_balance);
            }
            // fees[i] = _fee * difference / FEE_DENOMINATOR
            fees[i] = _fee.mul(difference).div(FEE_DENOMINATOR);
            // self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
            balances[i] = new_balances[i].sub(
                fees[i].mul(admin_fee).div(FEE_DENOMINATOR)
            );
            new_balances[i] = new_balances[i].sub(fees[i]);
        }
        uint256 D2 = get_D_mem(new_balances, amp);

        // token_amount: uint256 = (D0 - D2) * token_supply / D0
        uint256 token_amount = D0.sub(D2).mul(totalSupply()).div(D0);
        require(token_amount != 0, " # dev: zero tokens burned");
        token_amount = token_amount.add(uint256(1)); //  # In case of rounding errors - make it unfavorable for the "attacker"
        require(token_amount <= max_burn_amount, "Slippage screwed you");

        _burn(msg.sender, token_amount); //  # dev: insufficient funds
        for (uint256 i = 0; i < coins.length; i++) {
            if (amounts[i] != 0) {
                TransferHelper.safeTransfer(coins[i], msg.sender, amounts[i]);
            }
        }
        emit RemoveLiquidityImbalance(
            msg.sender,
            amounts,
            fees,
            D1,
            totalSupply().sub(token_amount)
        );
    }

    function get_y_D(
        uint256 A_,
        uint256 i,
        uint256[] memory xp,
        uint256 D
    ) internal view returns (uint256 y) {
        //Calculate x[i] if one reduces D from being calculated for xp to D
        // Done by solving quadratic equation iteratively.
        // x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
        // x_1**2 + b*x_1 = c
        // x_1 = (x_1**2 + c) / (2*x_1 + b)
        // # x in the input is converted to the same price/precision

        require(i >= 0, "# dev: i below zero");
        require(i < coins.length, "  # dev: i above coins.length");

        uint256 c = D;
        uint256 S_ = 0;
        uint256 Ann = A_.mul(coins.length);

        uint256 _x = 0;
        for (uint256 _i = 0; _i < coins.length; _i++) {
            if (_i != i) {
                _x = xp[_i];
            } else {
                continue;
            }
            // S_ += _x
            S_ = S_.add(_x);
            // c = c * D / (_x * coins.length)
            c = c.mul(D).div(_x.mul(coins.length));
        }
        // c = c * D / (Ann * coins.length)
        c = c.mul(D).div(Ann.mul(coins.length));
        // b: uint256 = S_ + D / Ann
        uint256 b = S_.add(D.div(Ann));
        uint256 y_prev = 0;
        y = D;
        for (uint256 _i = 0; _i < 255; _i++) {
            y_prev = y;
            // y = (y*y + c) / (2 * y + b - D)
            y = y.mul(y).add(c).div(y.mul(uint256(2)).add(b).sub(D));
            // # Equality with the precision of 1
            if (y > y_prev) {
                if (y.sub(y_prev) <= 1) {
                    break;
                }
            } else {
                if (y_prev.sub(y) <= 1) {
                    break;
                }
            }
        }
    }

    function _calc_withdraw_one_coin(uint256 _token_amount, uint256 i)
        internal
        view
        returns (uint256 r1, uint256 r2)
    {
        //# First, need to calculate
        // # * Get current D
        // # * Solve Eqn against y_i for D - _token_amount
        uint256 amp = _A();
        // _fee: uint256 = self.fee * coins.length / (4 * (coins.length - 1))
        uint256 _fee =
            fee.mul(coins.length).div(
                uint256(4).mul(uint256(coins.length).sub(uint256(1)))
            );

        uint256[] memory xp = _xp();

        uint256 D0 = get_D(xp, amp);
        // D1: uint256 = D0 - _token_amount * D0 / total_supply
        uint256 D1 = D0.sub(_token_amount.mul(D0).div(totalSupply()));
        uint256[] memory xp_reduced = xp;

        uint256 new_y = get_y_D(amp, i, xp, D1);
        // dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
        uint256 dy_0 = xp[i].sub(new_y).div(PRECISION_MUL[i]); //# w/o fees

        for (uint256 j = 0; j < coins.length; j++) {
            uint256 dx_expected = 0;
            if (j == i) {
                // dx_expected = xp[j] * D1 / D0 - new_y
                dx_expected = xp[j].mul(D1).div(D0).sub(new_y);
            } else {
                // dx_expected = xp[j] - xp[j] * D1 / D0
                dx_expected = xp[j].sub(xp[j].mul(D1).div(D0));
            }
            // xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
            xp_reduced[j] = xp_reduced[j].sub(
                _fee.mul(dx_expected).div(FEE_DENOMINATOR)
            );
        }
        // dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
        uint256 dy = xp_reduced[i].sub(get_y_D(amp, i, xp_reduced, D1));
        // dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
        dy = dy.sub(uint256(1)).div(PRECISION_MUL[i]); // # Withdraw less to account for rounding errors
        r1 = dy;
        r2 = dy_0.sub(dy);
    }

    function calc_withdraw_one_coin(uint256 _token_amount, uint256 i)
        external
        view
        returns (uint256 result)
    {
        (result, ) = _calc_withdraw_one_coin(_token_amount, i);
    }

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        uint256 i,
        uint256 min_amount
    ) external nonReentrant {
        // Remove _amount of liquidity all in a form of coin i
        require(!is_killed, " # dev: is killed");
        uint256 dy = 0;
        uint256 dy_fee = 0;
        (dy, dy_fee) = _calc_withdraw_one_coin(_token_amount, i);
        require(dy >= min_amount, "Not enough coins removed");

        // self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
        balances[i] = balances[i].sub(
            dy.add(dy_fee.mul(admin_fee).div(FEE_DENOMINATOR))
        );
        _burn(msg.sender, _token_amount); //# dev: insufficient funds
        TransferHelper.safeTransfer(coins[i], msg.sender, dy);
        emit RemoveLiquidityOne(msg.sender, _token_amount, dy);
    }

    function ramp_A(uint256 _future_A, uint256 _future_time)
        external
        onlyOwner
    {
        require(
            block.timestamp >= initial_A_time.add(MIN_RAMP_TIME),
            "block.timestamp >= self.initial_A_time + MIN_RAMP_TIME"
        );
        require(
            _future_time >= block.timestamp.add(MIN_RAMP_TIME),
            "  # dev: insufficient time"
        );

        uint256 _initial_A = _A();
        require(
            (_future_A > 0) && (_future_A < MAX_A),
            "(_future_A > 0) && (_future_A < MAX_A)"
        );
        require(
            ((_future_A >= _initial_A) &&
                (_future_A <= _initial_A.mul(MAX_A_CHANGE))) ||
                ((_future_A < _initial_A) &&
                    (_future_A.mul(MAX_A_CHANGE) >= _initial_A)),
            "complex conditions"
        );
        initial_A = _initial_A;
        future_A = _future_A;
        initial_A_time = block.timestamp;
        future_A_time = _future_time;

        emit RampA(_initial_A, _future_A, block.timestamp, _future_time);
    }

    function stop_ramp_A() external onlyOwner {
        uint256 current_A = _A();
        initial_A = current_A;
        future_A = current_A;
        initial_A_time = block.timestamp;
        future_A_time = block.timestamp;
        // # now (block.timestamp < t1) is always False, so we return saved A

        emit StopRampA(current_A, block.timestamp);
    }

    function commit_new_fee(uint256 new_fee, uint256 new_admin_fee)
        external
        onlyOwner
    {
        require(admin_actions_deadline == 0, "  # dev: active action");
        require(new_fee <= MAX_FEE, "  # dev: fee exceeds maximum");
        require(
            new_admin_fee <= MAX_ADMIN_FEE,
            "  # dev: admin fee exceeds maximum"
        );

        uint256 _deadline = block.timestamp.add(ADMIN_ACTIONS_DELAY);
        admin_actions_deadline = _deadline;
        future_fee = new_fee;
        future_admin_fee = new_admin_fee;

        emit CommitNewFee(_deadline, new_fee, new_admin_fee);
    }

    function apply_new_fee() external onlyOwner {
        require(
            block.timestamp >= admin_actions_deadline,
            "  # dev: insufficient time"
        );
        require(admin_actions_deadline != 0, "  # dev: no active action");

        admin_actions_deadline = 0;
        uint256 _fee = future_fee;
        uint256 _admin_fee = future_admin_fee;
        fee = _fee;
        admin_fee = _admin_fee;

        emit NewFee(_fee, _admin_fee);
    }

    function revert_new_parameters() external onlyOwner {
        admin_actions_deadline = 0;
        emit RevertNewParameters();
    }

    function revert_transfer_ownership() external onlyOwner {
        transfer_ownership_deadline = 0;
        emit RevertTransferOwnership();
    }

    function admin_balances(uint256 i) external view returns (uint256 balance) {
        balance = IERC20(coins[i]).balanceOf(address(this)).sub(balances[i]);
    }

    function withdraw_admin_fees() external onlyOwner {
        for (uint256 i = 0; i < coins.length; i++) {
            address c = coins[i];
            uint256 value = IERC20(c).balanceOf(address(this)).sub(balances[i]);
            if (value > 0) {
                TransferHelper.safeTransfer(c, msg.sender, value);
            }
        }
        emit WithdrawAdminFees();
    }

    function donate_admin_fees() external onlyOwner {
        for (uint256 i = 0; i < coins.length; i++) {
            balances[i] = IERC20(coins[i]).balanceOf(address(this));
        }
        emit DonateAdminFees();
    }

    function kill_me() external onlyOwner {
        require(
            kill_deadline > block.timestamp,
            "  # dev: deadline has passed"
        );
        is_killed = true;
        emit KillMe();
    }

    function unkill_me() external onlyOwner {
        is_killed = false;
        emit UnkillMe();
    }
}
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/lib/TransferHelper.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

// helper mBNBods for interacting with BEP20 tokens and sending BNB that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }
}

// File: contracts/CStablePool.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;







contract CStablePool is ERC20, Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    uint256 private FEE_DENOMINATOR = 10**10;
    uint256 private LENDING_PRECISION = 10**18;
    uint256 private PRECISION = 10**18; // The precision to convert to
    uint256[] private PRECISION_MUL = [1, 1, 1];
    uint256[] private RATES = [
        1000000000000000000,
        1000000000000000000,
        1000000000000000000
    ];
    uint256 private FEE_INDEX = 2; // Which coin may potentially have fees (USDT)

    uint256 private MAX_ADMIN_FEE = 10 * 10**9;
    uint256 private MAX_FEE = 5 * 10**9;
    uint256 private MAX_A = 10**6;
    uint256 private MAX_A_CHANGE = 10;

    uint256 private ADMIN_ACTIONS_DELAY = 3 * 86400;
    uint256 private MIN_RAMP_TIME = 86400;

    address[] public coins;
    uint256[] public balances;
    uint256 public fee; // fee * 1e10
    uint256 public admin_fee; // admin_fee * 1e10

    uint256 public initial_A;
    uint256 public future_A;
    uint256 public initial_A_time;
    uint256 public future_A_time;

    uint256 public admin_actions_deadline;
    uint256 public transfer_ownership_deadline;
    uint256 public future_fee;
    uint256 public future_admin_fee;
    address public future_owner;

    bool public is_killed;
    uint256 public kill_deadline;
    uint256 private KILL_DEADLINE_DT = 2 * 30 * 86400;

    uint256 public volume;

    // Events
    event TokenExchange(
        address buyer,
        uint256 sold_id,
        uint256 tokens_sold,
        uint256 bought_id,
        uint256 tokens_bought
    );

    event AddLiquidity(
        address provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 invariant,
        uint256 token_supply
    );

    event RemoveLiquidity(
        address provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 token_supply
    );

    event RemoveLiquidityOne(
        address provider,
        uint256 token_amount,
        uint256 coin_amount
    );

    event RemoveLiquidityImbalance(
        address provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 invariant,
        uint256 token_supply
    );

    event CommitNewAdmin(uint256 deadline, address admin);

    event NewAdmin(address admin);

    event CommitNewFee(uint256 deadline, uint256 fee, uint256 admin_fee);

    event NewFee(uint256 fee, uint256 admin_fee);

    event RampA(
        uint256 old_A,
        uint256 new_A,
        uint256 initial_time,
        uint256 future_time
    );

    event StopRampA(uint256 A, uint256 t);
    event UnkillMe();
    event KillMe();
    event DonateAdminFees();
    event WithdrawAdminFees();
    event RevertTransferOwnership();
    event RevertNewParameters();

    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _coins,
        uint256 _a,
        uint256 _fee,
        uint256 _admin_fee,
        address ownerAddress
    )  ERC20(_name, _symbol) {
        transferOwnership(ownerAddress);
        for (uint256 i = 0; i < _coins.length; i++) {
            require(_coins[i] != address(0), "BNB is not support.");
        }
        coins = _coins;
        initial_A = _a;
        future_A = _a;
        fee = _fee;
        admin_fee = _admin_fee;
        kill_deadline = block.timestamp.add(KILL_DEADLINE_DT);
        balances = new uint256[](coins.length);
        for (uint256 i = 0; i < coins.length; i++) {
            balances[i] = 0;
        }
    }

    function _A() internal view returns (uint256 A1) {
        // Handle ramping A up or down
        uint256 t1 = future_A_time;
        A1 = future_A;
        if (block.timestamp < t1) {
            uint256 A0 = initial_A;
            uint256 t0 = initial_A_time;
            // Expressions in uint256 cannot have negative numbers, thus "if"
            if (A1 > A0) {
                // return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)
                A1 = A0.add(
                    A1.sub(A0).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
                );
            } else {
                // return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)
                A1 = A0.sub(
                    A0.sub(A1).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
                );
            }
        } else {
            //if (t1 == 0 || block.timestamp >= t1)
            // retrun A1
        }
    }

    // overide

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {}

    function A() external view returns (uint256 A1) {
        A1 = _A();
    }

    function _xp() internal view returns (uint256[] memory result) {
        result = RATES;
        for (uint256 i = 0; i < coins.length; i++) {
            // result[i] = result[i] * self.balances[i] / LENDING_PRECISION
            result[i] = result[i].mul(balances[i]).div(LENDING_PRECISION);
        }
    }

    function _xp_mem(uint256[] memory _balances)
        internal
        view
        returns (uint256[] memory result)
    {
        result = RATES;
        for (uint256 i = 0; i < coins.length; i++) {
            // result[i] = result[i] * _balances[i] / PRECISION
            result[i] = result[i].mul(_balances[i]).div(PRECISION);
        }
    }

    function get_D(uint256[] memory xp, uint256 amp)
        internal
        view
        returns (uint256 D)
    {
        uint256 S = 0;
        for (uint256 i = 0; i < xp.length; i++) {
            uint256 _x = xp[i];
            // S += _x
            S = S.add(_x);
        }
        if (S == 0) {
            D = 0;
        }
        uint256 Dprev = 0;
        D = S;
        // Ann: uint256 = amp * coins.length
        uint256 Ann = amp.mul(coins.length);
        for (uint256 i = 0; i < 255; i++) {
            uint256 D_P = D;
            for (uint256 j = 0; j < xp.length; j++) {
                uint256 _x = xp[j];
                // D_P = D_P * D / (_x * coins.length)
                D_P = D_P.mul(D).div(_x.mul(uint256(coins.length))); // If division by 0, this will be borked: only withdrawal will work. And that is good
            }
            Dprev = D;
            // D = (Ann * S + D_P * coins.length) * D / ((Ann - 1) * D + (coins.length + 1) * D_P)
            uint256 numerator =
                Ann.mul(S).add(D_P.mul(uint256(coins.length))).mul(D);
            uint256 denominator =
                Ann.sub(uint256(1)).mul(D).add(
                    uint256(coins.length).add(uint256(1)).mul(D_P)
                );
            D = numerator.div(denominator);
            // Equality with the precision of 1
            if (D > Dprev) {
                if (D.sub(Dprev) <= 1) {
                    break;
                }
            } else {
                if (Dprev.sub(D) <= 1) {
                    break;
                }
            }
        }
    }

    function get_D_mem(uint256[] memory _balances, uint256 amp)
        internal
        view
        returns (uint256 D)
    {
        D = get_D(_xp_mem(_balances), amp);
    }

    function get_virtual_price() external view returns (uint256 price) {
        // Returns portfolio virtual price (for calculating profit)
        // scaled up by 1e18
        uint256 D = get_D(_xp(), _A());
        // # D is in the units similar to DAI (e.g. converted to precision 1e18)
        // # When balanced, D = n * x_u - total virtual value of the portfolio
        uint256 token_supply = totalSupply();
        // return D * PRECISION / token_supply
        price = D.mul(PRECISION).div(token_supply);
    }

    function calc_token_amount(uint256[] calldata amounts, bool deposit)
        external
        view
        returns (uint256 result)
    {
        // Simplified method to calculate addition or reduction in token supply at
        //     deposit or withdrawal without taking fees into account (but looking at
        //     slippage).
        //     Needed to prevent front-running, not for precise calculations!
        uint256[] memory _balances = balances;
        uint256 amp = _A();
        uint256 D0 = get_D_mem(_balances, amp);
        for (uint256 i = 0; i < coins.length; i++) {
            if (deposit) {
                // _balances[i] += amounts[i]
                _balances[i] = _balances[i].add(amounts[i]);
            } else {
                // _balances[i] -= amounts[i]
                _balances[i] = _balances[i].sub(amounts[i]);
            }
        }
        uint256 D1 = get_D_mem(_balances, amp);
        uint256 token_amount = totalSupply();
        uint256 diff = 0;
        if (deposit) {
            // diff = D1 - D0
            diff = D1.sub(D0);
        } else {
            diff = D0.sub(D1);
        }
        // return diff * token_amount / D0
        result = diff.mul(token_amount).div(D0);
    }

    function add_liquidity(uint256[] calldata amounts, uint256 min_mint_amount)
        external
        nonReentrant
    {
        require(!is_killed, "is killed");
        uint256[] memory fees = new uint256[](coins.length);
        // _fee: uint256 = self.fee * coins.length / (4 * (coins.length - 1))
        uint256 _fee =
            fee.mul(coins.length).div(
                uint256(4).mul(uint256(coins.length).sub(uint256(1)))
            );
        uint256 amp = _A();

        // # Initial invariant
        uint256 D0 = 0;
        uint256[] memory old_balances = balances;
        if (totalSupply() > 0) {
            D0 = get_D_mem(old_balances, amp);
        }
        uint256[] memory new_balances = old_balances;
        for (uint256 i = 0; i < coins.length; i++) {
            uint256 in_amount = amounts[i];
            if (totalSupply() == 0) {
                require(in_amount > 0, "initial deposit requires all coins"); // # dev: initial deposit requires all coins
            }
            address in_coin = coins[i];
            if (in_amount > 0) {
                // # Take coins from the sender
                if (i == FEE_INDEX) {
                    in_amount = IERC20(in_coin).balanceOf(address(this));
                }
                TransferHelper.safeTransferFrom(
                    in_coin,
                    msg.sender,
                    address(this),
                    amounts[i]
                );
                if (i == FEE_INDEX) {
                    // in_amount = ERC20(in_coin).balanceOf(self) - in_amount
                    in_amount = IERC20(in_coin).balanceOf(address(this)).sub(
                        in_amount
                    );
                }
            }
            // new_balances[i] = old_balances[i] + in_amount
            new_balances[i] = old_balances[i].add(in_amount);
        }
        // # Invariant after change
        uint256 D1 = get_D_mem(new_balances, amp);
        require(D1 > D0, "D1 must bigger than D0");

        // # We need to recalculate the invariant accounting for fees
        // # to calculate fair user's share
        uint256 D2 = D1;
        if (totalSupply() > 0) {
            for (uint256 i = 0; i < coins.length; i++) {
                // ideal_balance: uint256 = D1 * old_balances[i] / D0
                uint256 ideal_balance = D1.mul(old_balances[i]).div(D0);
                uint256 difference = 0;
                if (ideal_balance > new_balances[i]) {
                    // difference = ideal_balance - new_balances[i]
                    difference = ideal_balance.sub(new_balances[i]);
                } else {
                    // difference = new_balances[i] - ideal_balance
                    difference = new_balances[i].sub(ideal_balance);
                }
                // fees[i] = _fee * difference / FEE_DENOMINATOR
                fees[i] = _fee.mul(difference).div(FEE_DENOMINATOR);
                // self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
                balances[i] = new_balances[i].sub(
                    fees[i].mul(admin_fee).div(FEE_DENOMINATOR)
                );
                // new_balances[i] -= fees[i]
                new_balances[i] = new_balances[i].sub(fees[i]);
            }
            D2 = get_D_mem(new_balances, amp);
        } else {
            balances = new_balances;
        }
        // # Calculate, how much pool tokens to mint
        uint256 mint_amount = 0;
        if (totalSupply() == 0) {
            mint_amount = D1; //# Take the dust if there was any
        } else {
            // mint_amount = token_supply * (D2 - D0) / D0
            mint_amount = totalSupply().mul(D2.sub(D0)).div(D0);
        }

        require(mint_amount >= min_mint_amount, "Slippage screwed you");

        // # Mint pool tokens
        _mint(msg.sender, mint_amount);

        emit AddLiquidity(
            msg.sender,
            amounts,
            fees,
            D1,
            totalSupply().add(mint_amount)
        );
    }

    function get_y(
        uint256 i,
        uint256 j,
        uint256 x,
        uint256[] memory xp_
    ) internal view returns (uint256 y) {
        // # x in the input is converted to the same price/precision
        require(i != j, "dev: same coin");
        require(j >= 0, "dev: j below zero");
        require(j < coins.length, "dev: j above coins.length");

        // # should be unreachable, but good for safety
        require(i >= 0, "i must >= 0");
        require(i < coins.length, "i must < n_coins");
        uint256 amp = _A();
        uint256 D = get_D(xp_, amp);
        uint256 c = D;
        uint256 S_ = 0;
        // Ann: uint256 = amp * coins.length
        uint256 Ann = amp.mul(uint256(coins.length));

        uint256 _x = 0;
        for (uint256 _i = 0; _i < coins.length; _i++) {
            if (_i == i) {
                _x = x;
            } else if (_i != j) {
                _x = xp_[_i];
            } else {
                continue;
            }
            // S_ += _x
            S_ = S_.add(_x);
            // c = c * D / (_x * coins.length)
            c = c.mul(D).div(_x.mul(uint256(coins.length)));
        }
        // c = c * D / (Ann * coins.length)
        c = c.mul(D).div(Ann.mul(coins.length));
        // uint256 b = S_.add(D.div(Ann)); //# - D
        uint256 y_prev = 0;
        y = D;
        for (uint256 _i = 0; _i < 255; _i++) {
            y_prev = y;
            // b: uint256 = S_ + D / Ann  # - D
            // y = (y*y + c) / (2 * y + b - D)
            y = y.mul(y).add(c).div(
                y.mul(uint256(2)).add(S_.add(D.div(Ann))).sub(D)
            );
            // # Equality with the precision of 1
            if (y > y_prev) {
                if (y.sub(y_prev) <= 1) {
                    break;
                }
            } else {
                if (y_prev.sub(y) <= 1) {
                    break;
                }
            }
        }
    }

    function get_dy(
        uint256 i,
        uint256 j,
        uint256 dx
    ) external view returns (uint256 result) {
        // # dx and dy in c-units
        uint256[] memory xp = _xp();

        // x: uint256 = xp[i] + (dx * rates[i] / PRECISION)
        uint256 x = xp[i].add(dx.mul(RATES[i]).div(PRECISION));
        uint256 y = get_y(i, j, x, xp);
        // dy: uint256 = (xp[j] - y - 1) * PRECISION / rates[j]
        uint256 dy = xp[j].sub(y).sub(1).mul(PRECISION).div(RATES[j]);
        // _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
        uint256 _fee = fee.mul(dy).div(FEE_DENOMINATOR);
        result = dy.sub(_fee);
    }

    function get_dy_underlying(
        uint256 i,
        uint256 j,
        uint256 dx
    ) external view returns (uint256 result) {
        //# dx and dy in underlying units
        uint256[] memory xp = _xp();
        uint256[] memory precisions = PRECISION_MUL;

        // x: uint256 = xp[i] + dx * precisions[i]
        uint256 x = xp[i].add(dx.mul(precisions[i]));
        uint256 y = get_y(i, j, x, xp);
        // dy: uint256 = (xp[j] - y - 1) / precisions[j]
        uint256 dy = xp[j].sub(y).sub(uint256(1)).div(precisions[j]);
        // _fee: uint256 = self.fee * dy / FEE_DENOMINATOR
        uint256 _fee = fee.mul(dy).div(FEE_DENOMINATOR);
        // return dy - _fee
        result = dy.sub(_fee);
    }

    function exchange(
        uint256 i,
        uint256 j,
        uint256 dx,
        uint256 min_dy
    ) external nonReentrant {
        require(!is_killed, "dev: is killed");

        uint256[] memory xp = _xp_mem(balances);

        // # Handling an unexpected charge of a fee on transfer (USDT, PAXG)
        uint256 dx_w_fee = dx;
        address input_coin = coins[i];
        if (i == FEE_INDEX) {
            dx_w_fee = IERC20(input_coin).balanceOf(address(this));
        }
        // # "safeTransferFrom" which works for ERC20s which return bool or not
        TransferHelper.safeTransferFrom(
            input_coin,
            msg.sender,
            address(this),
            dx
        );
        if (i == FEE_INDEX) {
            // dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee
            dx_w_fee = IERC20(input_coin).balanceOf(address(this)).sub(
                dx_w_fee
            );
        }
        // x: uint256 = xp[i] + dx_w_fee * rates[i] / PRECISION
        uint256 x = xp[i].add(dx_w_fee.mul(RATES[i]).div(PRECISION));
        uint256 y = get_y(i, j, x, xp);

        // dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors
        uint256 dy = xp[j].sub(y).sub(uint256(1)); // # -1 just in case there were some rounding errors
        // dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR
        uint256 dy_fee = dy.mul(fee).div(FEE_DENOMINATOR);

        // # Convert all to real units
        // dy = (dy - dy_fee) * PRECISION / rates[j]
        dy = dy.sub(dy_fee).mul(PRECISION).div(RATES[j]);
        require(dy >= min_dy, "Exchange resulted in fewer coins than expected");

        // dy_admin_fee: uint256 = dy_fee * self.admin_fee / FEE_DENOMINATOR
        uint256 dy_admin_fee = dy_fee.mul(admin_fee).div(FEE_DENOMINATOR);
        // dy_admin_fee = dy_admin_fee * PRECISION / rates[j]
        dy_admin_fee = dy_admin_fee.mul(PRECISION).div(RATES[j]);

        // # Change balances exactly in same way as we change actual ERC20 coin amounts
        // self.balances[i] = old_balances[i] + dx_w_fee
        balances[i] = balances[i].add(dx_w_fee);
        // # When rounding errors happen, we undercharge admin fee in favor of LP
        // self.balances[j] = old_balances[j] - dy - dy_admin_fee
        balances[j] = balances[j].sub(dy).sub(dy_admin_fee);
        TransferHelper.safeTransfer(coins[j], msg.sender, dy);
        volume = volume.add(dx);
        emit TokenExchange(msg.sender, i, dx, j, dy);
    }

    function remove_liquidity(uint256 _amount, uint256[] calldata min_amounts)
        external
        nonReentrant
    {
        uint256 total_supply = totalSupply();
        uint256[] memory amounts = new uint256[](coins.length);
        uint256[] memory fees = new uint256[](coins.length); //  # Fees are unused but we've got them historically in event
        for (uint256 i = 0; i < coins.length; i++) {
            // value: uint256 = self.balances[i] * _amount / total_supply
            uint256 value = balances[i].mul(_amount).div(total_supply);
            require(
                value >= min_amounts[i],
                "Withdrawal resulted in fewer coins than expected"
            );
            // self.balances[i] -= value
            balances[i] = balances[i].sub(value);
            amounts[i] = value;
            TransferHelper.safeTransfer(coins[i], msg.sender, value);
        }
        _burn(msg.sender, _amount); // # dev: insufficient funds

        emit RemoveLiquidity(
            msg.sender,
            amounts,
            fees,
            total_supply.sub(_amount)
        );
    }

    function remove_liquidity_imbalance(
        uint256[] calldata amounts,
        uint256 max_burn_amount
    ) external nonReentrant {
        require(!is_killed, "is killed"); //not self.  # dev: is killed

        require(totalSupply() != 0, "  # dev: zero total supply");
        // _fee: uint256 = self.fee * coins.length / (4 * (coins.length - 1))
        uint256 _fee = fee.mul(coins.length).div(coins.length.sub(1).mul(4));
        // uint256 _admin_fee = admin_fee;
        uint256 amp = _A();

        uint256[] memory old_balances = balances;
        uint256[] memory new_balances = old_balances;
        uint256 D0 = get_D_mem(old_balances, amp);
        for (uint256 i = 0; i < coins.length; i++) {
            // new_balances[i] -= amounts[i]
            new_balances[i] = new_balances[i].sub(amounts[i]);
        }
        uint256 D1 = get_D_mem(new_balances, amp);
        uint256[] memory fees = new uint256[](coins.length);
        for (uint256 i = 0; i < coins.length; i++) {
            // ideal_balance: uint256 = D1 * old_balances[i] / D0
            uint256 ideal_balance = D1.mul(old_balances[i]).div(D0);
            uint256 difference = 0;
            if (ideal_balance > new_balances[i]) {
                // difference = ideal_balance - new_balances[i]
                difference = ideal_balance.sub(new_balances[i]);
            } else {
                // difference = new_balances[i] - ideal_balance
                difference = new_balances[i].sub(ideal_balance);
            }
            // fees[i] = _fee * difference / FEE_DENOMINATOR
            fees[i] = _fee.mul(difference).div(FEE_DENOMINATOR);
            // self.balances[i] = new_balances[i] - (fees[i] * _admin_fee / FEE_DENOMINATOR)
            balances[i] = new_balances[i].sub(
                fees[i].mul(admin_fee).div(FEE_DENOMINATOR)
            );
            new_balances[i] = new_balances[i].sub(fees[i]);
        }
        uint256 D2 = get_D_mem(new_balances, amp);

        // token_amount: uint256 = (D0 - D2) * token_supply / D0
        uint256 token_amount = D0.sub(D2).mul(totalSupply()).div(D0);
        require(token_amount != 0, " # dev: zero tokens burned");
        token_amount = token_amount.add(uint256(1)); //  # In case of rounding errors - make it unfavorable for the "attacker"
        require(token_amount <= max_burn_amount, "Slippage screwed you");

        _burn(msg.sender, token_amount); //  # dev: insufficient funds
        for (uint256 i = 0; i < coins.length; i++) {
            if (amounts[i] != 0) {
                TransferHelper.safeTransfer(coins[i], msg.sender, amounts[i]);
            }
        }
        emit RemoveLiquidityImbalance(
            msg.sender,
            amounts,
            fees,
            D1,
            totalSupply().sub(token_amount)
        );
    }

    function get_y_D(
        uint256 A_,
        uint256 i,
        uint256[] memory xp,
        uint256 D
    ) internal view returns (uint256 y) {
        //Calculate x[i] if one reduces D from being calculated for xp to D
        // Done by solving quadratic equation iteratively.
        // x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
        // x_1**2 + b*x_1 = c
        // x_1 = (x_1**2 + c) / (2*x_1 + b)
        // # x in the input is converted to the same price/precision

        require(i >= 0, "# dev: i below zero");
        require(i < coins.length, "  # dev: i above coins.length");

        uint256 c = D;
        uint256 S_ = 0;
        uint256 Ann = A_.mul(coins.length);

        uint256 _x = 0;
        for (uint256 _i = 0; _i < coins.length; _i++) {
            if (_i != i) {
                _x = xp[_i];
            } else {
                continue;
            }
            // S_ += _x
            S_ = S_.add(_x);
            // c = c * D / (_x * coins.length)
            c = c.mul(D).div(_x.mul(coins.length));
        }
        // c = c * D / (Ann * coins.length)
        c = c.mul(D).div(Ann.mul(coins.length));
        // b: uint256 = S_ + D / Ann
        uint256 b = S_.add(D.div(Ann));
        uint256 y_prev = 0;
        y = D;
        for (uint256 _i = 0; _i < 255; _i++) {
            y_prev = y;
            // y = (y*y + c) / (2 * y + b - D)
            y = y.mul(y).add(c).div(y.mul(uint256(2)).add(b).sub(D));
            // # Equality with the precision of 1
            if (y > y_prev) {
                if (y.sub(y_prev) <= 1) {
                    break;
                }
            } else {
                if (y_prev.sub(y) <= 1) {
                    break;
                }
            }
        }
    }

    function _calc_withdraw_one_coin(uint256 _token_amount, uint256 i)
        internal
        view
        returns (uint256 r1, uint256 r2)
    {
        //# First, need to calculate
        // # * Get current D
        // # * Solve Eqn against y_i for D - _token_amount
        uint256 amp = _A();
        // _fee: uint256 = self.fee * coins.length / (4 * (coins.length - 1))
        uint256 _fee =
            fee.mul(coins.length).div(
                uint256(4).mul(uint256(coins.length).sub(uint256(1)))
            );

        uint256[] memory xp = _xp();

        uint256 D0 = get_D(xp, amp);
        // D1: uint256 = D0 - _token_amount * D0 / total_supply
        uint256 D1 = D0.sub(_token_amount.mul(D0).div(totalSupply()));
        uint256[] memory xp_reduced = xp;

        uint256 new_y = get_y_D(amp, i, xp, D1);
        // dy_0: uint256 = (xp[i] - new_y) / precisions[i]  # w/o fees
        uint256 dy_0 = xp[i].sub(new_y).div(PRECISION_MUL[i]); //# w/o fees

        for (uint256 j = 0; j < coins.length; j++) {
            uint256 dx_expected = 0;
            if (j == i) {
                // dx_expected = xp[j] * D1 / D0 - new_y
                dx_expected = xp[j].mul(D1).div(D0).sub(new_y);
            } else {
                // dx_expected = xp[j] - xp[j] * D1 / D0
                dx_expected = xp[j].sub(xp[j].mul(D1).div(D0));
            }
            // xp_reduced[j] -= _fee * dx_expected / FEE_DENOMINATOR
            xp_reduced[j] = xp_reduced[j].sub(
                _fee.mul(dx_expected).div(FEE_DENOMINATOR)
            );
        }
        // dy: uint256 = xp_reduced[i] - self.get_y_D(amp, i, xp_reduced, D1)
        uint256 dy = xp_reduced[i].sub(get_y_D(amp, i, xp_reduced, D1));
        // dy = (dy - 1) / precisions[i]  # Withdraw less to account for rounding errors
        dy = dy.sub(uint256(1)).div(PRECISION_MUL[i]); // # Withdraw less to account for rounding errors
        r1 = dy;
        r2 = dy_0.sub(dy);
    }

    function calc_withdraw_one_coin(uint256 _token_amount, uint256 i)
        external
        view
        returns (uint256 result)
    {
        (result, ) = _calc_withdraw_one_coin(_token_amount, i);
    }

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        uint256 i,
        uint256 min_amount
    ) external nonReentrant {
        // Remove _amount of liquidity all in a form of coin i
        require(!is_killed, " # dev: is killed");
        uint256 dy = 0;
        uint256 dy_fee = 0;
        (dy, dy_fee) = _calc_withdraw_one_coin(_token_amount, i);
        require(dy >= min_amount, "Not enough coins removed");

        // self.balances[i] -= (dy + dy_fee * self.admin_fee / FEE_DENOMINATOR)
        balances[i] = balances[i].sub(
            dy.add(dy_fee.mul(admin_fee).div(FEE_DENOMINATOR))
        );
        _burn(msg.sender, _token_amount); //# dev: insufficient funds
        TransferHelper.safeTransfer(coins[i], msg.sender, dy);
        emit RemoveLiquidityOne(msg.sender, _token_amount, dy);
    }

    function ramp_A(uint256 _future_A, uint256 _future_time)
        external
        onlyOwner
    {
        require(
            block.timestamp >= initial_A_time.add(MIN_RAMP_TIME),
            "block.timestamp >= self.initial_A_time + MIN_RAMP_TIME"
        );
        require(
            _future_time >= block.timestamp.add(MIN_RAMP_TIME),
            "  # dev: insufficient time"
        );

        uint256 _initial_A = _A();
        require(
            (_future_A > 0) && (_future_A < MAX_A),
            "(_future_A > 0) && (_future_A < MAX_A)"
        );
        require(
            ((_future_A >= _initial_A) &&
                (_future_A <= _initial_A.mul(MAX_A_CHANGE))) ||
                ((_future_A < _initial_A) &&
                    (_future_A.mul(MAX_A_CHANGE) >= _initial_A)),
            "complex conditions"
        );
        initial_A = _initial_A;
        future_A = _future_A;
        initial_A_time = block.timestamp;
        future_A_time = _future_time;

        emit RampA(_initial_A, _future_A, block.timestamp, _future_time);
    }

    function stop_ramp_A() external onlyOwner {
        uint256 current_A = _A();
        initial_A = current_A;
        future_A = current_A;
        initial_A_time = block.timestamp;
        future_A_time = block.timestamp;
        // # now (block.timestamp < t1) is always False, so we return saved A

        emit StopRampA(current_A, block.timestamp);
    }

    function commit_new_fee(uint256 new_fee, uint256 new_admin_fee)
        external
        onlyOwner
    {
        require(admin_actions_deadline == 0, "  # dev: active action");
        require(new_fee <= MAX_FEE, "  # dev: fee exceeds maximum");
        require(
            new_admin_fee <= MAX_ADMIN_FEE,
            "  # dev: admin fee exceeds maximum"
        );

        uint256 _deadline = block.timestamp.add(ADMIN_ACTIONS_DELAY);
        admin_actions_deadline = _deadline;
        future_fee = new_fee;
        future_admin_fee = new_admin_fee;

        emit CommitNewFee(_deadline, new_fee, new_admin_fee);
    }

    function apply_new_fee() external onlyOwner {
        require(
            block.timestamp >= admin_actions_deadline,
            "  # dev: insufficient time"
        );
        require(admin_actions_deadline != 0, "  # dev: no active action");

        admin_actions_deadline = 0;
        uint256 _fee = future_fee;
        uint256 _admin_fee = future_admin_fee;
        fee = _fee;
        admin_fee = _admin_fee;

        emit NewFee(_fee, _admin_fee);
    }

    function revert_new_parameters() external onlyOwner {
        admin_actions_deadline = 0;
        emit RevertNewParameters();
    }

    function revert_transfer_ownership() external onlyOwner {
        transfer_ownership_deadline = 0;
        emit RevertTransferOwnership();
    }

    function admin_balances(uint256 i) external view returns (uint256 balance) {
        balance = IERC20(coins[i]).balanceOf(address(this)).sub(balances[i]);
    }

    function withdraw_admin_fees() external onlyOwner {
        for (uint256 i = 0; i < coins.length; i++) {
            address c = coins[i];
            uint256 value = IERC20(c).balanceOf(address(this)).sub(balances[i]);
            if (value > 0) {
                TransferHelper.safeTransfer(c, msg.sender, value);
            }
        }
        emit WithdrawAdminFees();
    }

    function donate_admin_fees() external onlyOwner {
        for (uint256 i = 0; i < coins.length; i++) {
            balances[i] = IERC20(coins[i]).balanceOf(address(this));
        }
        emit DonateAdminFees();
    }

    function kill_me() external onlyOwner {
        require(
            kill_deadline > block.timestamp,
            "  # dev: deadline has passed"
        );
        is_killed = true;
        emit KillMe();
    }

    function unkill_me() external onlyOwner {
        is_killed = false;
        emit UnkillMe();
    }
}
