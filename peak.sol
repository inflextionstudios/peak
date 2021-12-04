// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface BEP20 {
    function totalSupply() external view returns (uint256);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint a, uint b) public pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint a, uint b) public pure returns (uint) {
        require(b <= a);
        return a - b;
    }
}

contract PEAK is BEP20 {
    string private _symbol;
    string private _name;
    uint8 private _decimals;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    using SafeMath for uint256;

    constructor() {
        address _contractCreator = msg.sender;
        _symbol = "PEAK";
        _name = "Peakmines PEAK";
        _decimals = 18;
        _totalSupply = 10000000 * (10 ** _decimals);
        _balances[_contractCreator] = _totalSupply;
        emit Transfer(address(0), _contractCreator, _totalSupply);
    }

    // Returns the token name
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    // Returns the token symbol
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    // Returns the token decimals
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    // Returns the amount of tokens that exists
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Returns the amount of tokens owned by address
    function balanceOf(address _address)
        public
        view
        override
        returns (uint256)
    {
        return _balances[_address];
    }

    // Transfer an amount of your own tokens to another address
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool)
    {
        address _from = msg.sender;
        bool _enoughBalance = _balances[_from] >= _value;
        bool _isValidAddressToTransfer = _to != address(0);

        require(_enoughBalance, "Insufficient balance");
        require(_isValidAddressToTransfer, "Invalid transaction");

        _balances[_from] = _balances[_from].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(_from, _to, _value);

        return true;
    }

    // Authorize another address to transfer an amount of your tokens
    function approve(address _delegate, uint256 _value)
        public
        override
        returns (bool)
    {
        bool _isValidAddressToDelegate = _delegate != address(0);

        require(_isValidAddressToDelegate, "Invalid transaction");

        address _tokenOwner = msg.sender;
        _allowances[_tokenOwner][_delegate] = _value;
        emit Approval(_tokenOwner, _delegate, _value);

        return true;
    }

    // Transfer an amount of tokens from an authorized address to another address.
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool) {
        address _delegate = msg.sender;
        bool _isAllowed = _allowances[_from][_delegate] >= _value;
        bool _enoughBalance = _balances[_from] >= _value;
        bool _isValidAddressToTransfer = _to != address(0);

        require(_isAllowed, "Unauthorized");
        require(_enoughBalance, "Insufficient balance");
        require(_isValidAddressToTransfer, "Invalid transaction");

        _balances[_from] = _balances[_from].sub(_value);
        _allowances[_from][_delegate] = _allowances[_from][_delegate].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(_from, _to, _value);

        return true;
    }

    // Returns a delegate's allowance for an address
    function allowance(address _tokenOwner, address _delegate)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[_tokenOwner][_delegate];
    }

    // Increase a delegate's allowance 
    function increaseAllowance(address _delegate, uint256 _addedValue)
        public
        returns (bool)
    {   
        address _tokenOwner = msg.sender;
        uint _value = _allowances[_tokenOwner][_delegate].add(_addedValue);
        approve(_delegate, _value);
        return true;
    }

    // Decrease a delegate's allowance 
    function decreaseAllowance(address _delegate, uint256 _subtractedValue)
        public
        returns (bool)
    {
        address _tokenOwner = msg.sender;
        uint256 _delegateAllowance = _allowances[_tokenOwner][_delegate];
        bool _hasEnoughAllowance = _delegateAllowance >= _subtractedValue;

        require(_hasEnoughAllowance, "Invalid value");

        uint256 _value = _delegateAllowance.sub(_subtractedValue);

        approve(_delegate, _value);
        return true;
    }
}
