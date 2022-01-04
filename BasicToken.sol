pragma solidity 0.8.8;

import  "./Pauseable.sol";


/**
 * @title TRC20Basic
 * @dev Simpler version of TRC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
 pragma solidity 0.8.8;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

library SafeMath {

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */

    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
}

abstract contract BEP20Basic {
    uint public totalSupply;
     function balanceOf(address who) virtual public view returns (uint256);
     function transfer(address to, uint256 value) virtual public returns(bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title Basic Token
 * @dev Basic version of Standard Token, with no allowances. 
 */

abstract contract BasicToken is BEP20Basic, Pauseable {
    
    using SafeMath for uint256;
    
    mapping(address => uint256) internal Frozen;
    
    mapping(address => uint256) internal _balances;
    
    /**
     * @dev transfer token to a specified address
     * @param to The address to which tokens are transfered.
     * @param value The amount which is transferred.
     */
    
    function  transfer(address to, uint256 value) override public  stoppable validRecipient(to) returns(bool) {
        _transfer(msg.sender, to, value);
        return true;
    }
    
    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0));
        require(value > 0);
        require(_balances[from].sub(Frozen[from]) >= value);
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Gets the balance of a specified address.
     * @param _owner is the address to query the balance of. 
     * @return uint256 representing the amount owned by the address.
     */

   function balanceOf(address _owner) override public view returns(uint256) {
      return _balances[_owner];
    }

    /**
     * @dev Gets the available balance of a specified address which is not frozen.
     * @param _owner is the address to query the available balance of. 
     * @return uint256 representing the amount owned by the address which is not frozen.
     */

    function availableBalance(address _owner) public view returns(uint256) {
        return _balances[_owner].sub(Frozen[_owner]);
    }

    /**
     * @dev Gets the frozen balance of a specified address.
     * @param _owner is the address to query the frozen balance of. 
     * @return uint256 representing the amount owned by the address which is frozen.
     */

    function frozenOf(address _owner) public view returns(uint256) {
        return Frozen[_owner];
    }

    /**
     * @dev a modifier to avoid a functionality to be applied on zero address and token contract.
     */

    modifier validRecipient(address _recipient) {
        require(_recipient != address(0) && _recipient != address(this));
    _;
    }
}
