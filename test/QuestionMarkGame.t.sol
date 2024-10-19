// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/QuestionMarkGame.sol";

contract QuestionMarkGameTest is Test {
    QuestionMarkGame public game;

    function setUp() public {
        game = new QuestionMarkGame();
    }

    function testPrint() public view {
        uint256 seed = 3;
        uint256[numCards] memory permutation = game.generatePermutation(numCards, seed);
        for (uint256 i = 0; i < numCards; i++) {
            console2.log(permutation[i]);
        }
    }

    function testGeneratePermutation(uint256 seed) public view {
        uint256[numCards] memory permutation = game.generatePermutation(numCards, seed);
        bool[numCards] memory numberUsed;
        for (uint256 i = 0; i < numCards; i++) {
            uint pi = permutation[i];
            assert(pi < numCards);
            if (numberUsed[pi]) assert(false);
            numberUsed[pi] = true;
        }
    }
}
