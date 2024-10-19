// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";

// 0,1,2,3
// a,b,c,d
// 0000, 0130, 1022 , ...\

uint256  constant numCards = 4 ** 4;
// uint256  constant numCards = 5;

contract QuestionMarkGame {
    
    function generatePermutation(uint256 N, uint256 seed) public pure returns (uint256[numCards] memory permutation) {
        for (uint256 i = 0; i < N; i++) {
            permutation[i] = i;
        }
        for (uint256 i = N - 1; i > 0; i--) {
            uint256 j = random(seed, i + 1);
            (permutation[i], permutation[j]) = (permutation[j], permutation[i]);
            seed = uint256(keccak256(abi.encodePacked(seed, i)));
        }

    }

    function random(uint256 seed, uint256 upperBound) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed))) % upperBound;
    }
}
