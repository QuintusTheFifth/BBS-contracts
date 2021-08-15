pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract YourContract is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIdCounter;

  struct BBlock {
    bytes11 FATname; // 8.3 DOS filename
    bytes contentXXX; // implement after ipfs
    string tokenURI;
  }

  event SetPurpose(address sender, string purpose);
  event Mint(address sender, uint256 tokenId);
  event SetTokenURI(address sender, uint256 tokenId, string tokenURI);

  string public purpose = "Bulletin Block System";

  error EmptyPurposeError(uint code, string message);

  //constructor() {
  constructor() ERC721("BulletinBlock", "BBLK") {
    // what should we do on deploy?
  }

  function setPurpose(string memory newPurpose) public {
      if(bytes(newPurpose).length == 0){
          revert EmptyPurposeError({
              code: 1,
              message: "Purpose can not be empty"
          });
      }

      purpose = newPurpose;
      console.log(msg.sender,"set purpose to",purpose);
      emit SetPurpose(msg.sender, purpose);
  }
  function mint() public {
    // TODO require payment for DAO operations
    uint256 newTokenId = _tokenIdCounter.current();
    _safeMint(msg.sender, newTokenId);
    _tokenIdCounter.increment();
    emit Mint(msg.sender, newTokenId);
  }
  function safeMint(address to) public onlyOwner {
      _safeMint(to, _tokenIdCounter.current());
      _tokenIdCounter.increment();
  }
  function tokenOfOwnerByIndex(address owner, uint256 index)
    public
    view
    override(ERC721Enumerable)
    returns (uint256)
  {
    return super.tokenOfOwnerByIndex(owner, index);
  }

  function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
    require(msg.sender == ERC721.ownerOf(tokenId), "You don't own this NFT");
      _setTokenURI(tokenId, _tokenURI);
      emit SetTokenURI(msg.sender, tokenId, _tokenURI);
  }
  /*
  function createPool(string calldata name, uint256 stratId) public payable {// {{{
    // TODO require payment for DAO operations
    uint256 newTokenId = _tokenIdCounter.current();
    _safeMint(msg.sender, newTokenId);
    // when a map: poolNames[newTokenId] = name;
    // TODO set an approved Strat
    poolNames.push(name);
    poolStratId.push(stratId);
    poolCount++;
    _tokenIdCounter.increment();
    emit CreatePool(msg.sender, name, stratId);
  }
  function depositPool(uint256 poolId, uint256 tokenAmount) public payable {
    require(poolId < _tokenIdCounter.current());
    // TODO move the funds around
    // call deposit of approved strat at poolStratId[poolId]
    // assumes now for maturationTimestamp
    emit DepositPool(msg.sender, "Deposited token into pool, immediately withdrawable", poolNames[poolId], tokenAmount);
  }
  function harvestPool(uint256 poolId) public onlyOwner {
    require(poolId < _tokenIdCounter.current());
    // TODO move the funds around
  }
  function approveStrat(address addr, string calldata name) public onlyOwner {
    // string name = "Whats My Name";
    Strat memory s = Strat(addr, name);
    approvedStrats.push(s);
  }
  */// }}}

  // Copied ERC721 stuff
  function pause() public onlyOwner {
    _pause();
  }

  function unpause() public onlyOwner {
    _unpause();
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    whenNotPaused
    override(ERC721, ERC721Enumerable)
  {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
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
    override(ERC721, ERC721Enumerable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
