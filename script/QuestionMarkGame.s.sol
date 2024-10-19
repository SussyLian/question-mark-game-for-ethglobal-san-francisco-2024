// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {QuestionMarkGame} from "../src/QuestionMarkGame.sol";

contract CounterScript is Script {
    QuestionMarkGame public game;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        game = new QuestionMarkGame();

        vm.stopBroadcast();
    }
}
