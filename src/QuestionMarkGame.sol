// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";

// 0,1,2,3
// a,b,c,d
// 0000, 0130, 1022 , ...\

uint256  constant numCards = 4 ** 4;
// uint256  constant numCards = 5;

contract QuestionMarkGame {

    // Maps the 4 values of the card to a single number (0 to 255)
    function cardToNumber(uint256[4] memory cardValues) public pure returns (uint256) {
        require(cardValues.length == 4, "Card must have exactly 4 values.");
        uint256 result = 0;
        for (uint256 i = 0; i < 4; i++) {
            require(cardValues[i] < 4, "Each value must be between 0 and 3.");
            result += cardValues[i] * uint256(4**i);
        }
        return result;
    }

    // Maps a number (0 to 255) back to the 4 values of the card
    function numberToCard(uint256 number) public pure returns (uint256[4] memory) {
        require(number < 256, "Number must be between 0 and 255.");
        uint256[4] memory cardValues;
        for (uint256 i = 0; i < 4; i++) {
            cardValues[i] = number % 4;
            number /= 4;
        }
        return cardValues;
    }
    
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
