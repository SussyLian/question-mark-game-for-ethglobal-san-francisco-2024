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

    function testNumberToCard() public view {
        for (uint256 i = 0; i < numCards; i++) {
            console2.log('card # ', i);
            uint256[4] memory card = game.numberToCard(i);
            console2.log(card[0], card[1], card[2], card[3]);
        }
    }

    function testNumberToCardToNumber(uint number) public view {
        number = bound(number, 0, numCards-1);
        uint256[4] memory card = game.numberToCard(number);
        uint number2 = game.cardToNumber(card);
        assert(number == number2);
    }
}
