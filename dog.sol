// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Dogs is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 MAX_AMOUNT = 5;
    string uri = "";
    mapping(address => bool) private whiteList;
    bool private white_mint_open=false;
    bool private pub_mint_open=false;
    uint256 MAX_MINT = 3;

    using Counters for Counters.Counter;
    Counters.Counter private _counter;

    constructor(address initialOwner)
        ERC721("Dogs", "DGS")
        Ownable(initialOwner)
    {}


    function mint() private{
        require(msg.value == 0.005 ether, "require 0.005 eth");
        require(totalSupply()< MAX_AMOUNT,"max amount");
        require(balanceOf(msg.sender)<MAX_MINT,"mint too much");
        uint256 tokenId = _counter.current();
        _counter.increment();
        
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function white_mint() public payable{
        require(white_mint_open,"white mint not open");
        require(whiteList[msg.sender],"not white list");
        mint();
    }

    function pub_mint() public payable{
        require(pub_mint_open,"public mint not open");
        mint();
    }

    function add_white_list(address[] calldata add) public onlyOwner {
        for(uint256 i=0;i<add.length;i++){
            whiteList[add[i]] = true;
        }
    }

    function open_white() public onlyOwner{
        white_mint_open = true;
    }

    function open_pub() public onlyOwner{
        pub_mint_open = true;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
