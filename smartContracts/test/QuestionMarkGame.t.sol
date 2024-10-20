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
        // uint256 seed = 3;
        // uint256[NUM_CARDS] memory permutation = game.generatePermutation(seed);
        // for (uint256 i = 0; i < NUM_CARDS; i++) {
        //     console2.log(permutation[i]);
        // }
    }

    function testGeneratePermutation(uint256 seed) public view {
        // uint256[NUM_CARDS] memory permutation = game.generatePermutation(seed);
        // bool[NUM_CARDS] memory numberUsed;
        // for (uint256 i = 0; i < NUM_CARDS; i++) {
        //     uint pi = permutation[i];
        //     assert(pi < NUM_CARDS);
        //     if (numberUsed[pi]) assert(false);
        //     numberUsed[pi] = true;
        // }
    }

    function testNumberToCard() public view {
        for (uint256 i = 0; i < NUM_CARDS; i++) {
            console2.log('card # ', i);
            uint256[4] memory card = game.numberToCard(i);
            console2.log(card[0], card[1], card[2], card[3]);
        }
    }

    function testNumberToCardToNumber(uint number) public view {
        number = bound(number, 0, NUM_CARDS-1);
        uint256[4] memory card = game.numberToCard(number);
        uint number2 = game.cardToNumber(card);
        assert(number == number2);
    }
    
    // function testIsGuessCorrect() public pure {
    //     uint[BOARD_WIDTH][BOARD_WIDTH] memory board = [[uint(5), 6, 10], [uint(1), 24, 23], [uint(7), 99, 100]];

    // }

    // function printBoard(uint[BOARD_WIDTH][BOARD_WIDTH] memory board) {
        // todo
    // }
}
