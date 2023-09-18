// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract Staker is IERC721Receiver, ERC721Holder{

    IERC20 immutable token;
    IERC721 immutable NFT;

    mapping(address => mapping(uint256 => uint256)) public stakes;
    mapping(uint => uint) public timelock;

    constructor(address _token, address _NFT) {
        token = IERC20(_token);
        NFT = IERC721(_NFT);
    }

    function calculateRate(uint256 time) private pure returns(uint8) {
        if(time < 7 days) {
            return 0;
        } else if (time < 28 days) {
            return 2;
        } else {
            return 3;
        }
    }

    function stake(uint256 _tokenId) public {
        require(NFT.ownerOf(_tokenId) == msg.sender, "Caller is not the owner");
        stakes[msg.sender][_tokenId] = block.timestamp;
        NFT.safeTransferFrom(msg.sender, address(this), _tokenId, "");
    }

    function calculateReward(uint256 _tokenId) public view returns (uint256 reward) {
        require(stakes[msg.sender][_tokenId] > 0, "NFT has not been staked");
        uint256 time = block.timestamp - stakes[msg.sender][_tokenId];
        uint256 reward = calculateRate(time) * time * (10 ** 18) / 1 days;
        return reward;
    }

    function unstake(uint256 _tokenId) public {
        require(NFT.ownerOf(_tokenId) == msg.sender, "Caller is not the owner");
        uint256 reward = calculateReward(_tokenId);
        delete stakes[msg.sender][_tokenId];
        NFT.safeTransferFrom(address(this), msg.sender, _tokenId, "");

        token.safeTransfer(msg.sender, reward);
    }

}
