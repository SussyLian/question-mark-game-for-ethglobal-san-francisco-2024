//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

uint constant WIN_THRESHOLD = 10;
uint constant NUM_CARDS = 4 ** 4;
uint constant BOARD_WIDTH = 3;
uint constant COLUMN = 0;
uint constant ROW = 1;
uint constant BOTTOM_LEFT = 0;
uint constant BOTTOM_RIGHT = 1;
uint constant TOP_RIGHT = 2;
uint constant TOP_LEFT = 3;
address constant ZERO_ADDRESS = address(0);

contract QuestionMarkGame {

    mapping(uint => address) winnerPerBoard;
    mapping(uint => mapping(uint => mapping(address => bool))) guessedPerBoardPerTargetCardPerPlayer;
    mapping(uint => mapping(address => uint)) numCorrectPerBoardPerPlayer;
    
    function check(uint targetCard, uint[2] memory guessCoordinates) private pure {
        require(targetCard < NUM_CARDS);
        require(0 < guessCoordinates[COLUMN]);
        require(guessCoordinates[COLUMN] < 2*BOARD_WIDTH);
        require(0 < guessCoordinates[ROW]);
        require(guessCoordinates[ROW] < 2*BOARD_WIDTH);
    }

    function claimWin(uint seed) public {
        if (winnerPerBoard[seed] == ZERO_ADDRESS) return;
        if (numCorrectPerBoardPerPlayer[seed][msg.sender] < WIN_THRESHOLD) return;
        winnerPerBoard[seed] = msg.sender;
    }

    function guess(uint seed, uint targetCard, uint[2] memory guessCoordinates) public {
        console.log('guess, seed', seed);
        console.log('guess, targetCard', targetCard);
        console.log('guess, guessCoordinates[0]', guessCoordinates[0]);
        console.log('guess, guessCoordinates[1]', guessCoordinates[1]);
        console.log('guess, numCorrectPerBoardPerPlayer[seed][msg.sender]', numCorrectPerBoardPerPlayer[seed][msg.sender]);
        
        check(targetCard, guessCoordinates);

        if (guessedPerBoardPerTargetCardPerPlayer[seed][targetCard][msg.sender]) return;
        console.log('guess, 2');
        guessedPerBoardPerTargetCardPerPlayer[seed][targetCard][msg.sender] = true;
        uint256[BOARD_WIDTH][BOARD_WIDTH] memory board = generatePermutation(seed);
        if (isGuessCorrect(board, targetCard, guessCoordinates)) numCorrectPerBoardPerPlayer[seed][msg.sender]++;
    }

    function isGuessCorrect(uint[BOARD_WIDTH][BOARD_WIDTH] memory board, uint targetCard, uint[2] memory guessCoordinates) private pure returns (bool) {
        check(targetCard, guessCoordinates);

        uint256[4] memory targetCardValues = numberToCard(targetCard);

        if (guessCoordinates[COLUMN] % 2 == 1 && guessCoordinates[ROW] % 2 == 1) {
            // exact card
            uint boardCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            return targetCard == boardCard;
        } else if (guessCoordinates[COLUMN] % 2 == 0 && guessCoordinates[ROW] % 2 == 0) {
            // 4 cards
            uint bottomLeftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2 - 1];
            uint256[4] memory bottomLeftCardValues = numberToCard(bottomLeftCard);
            uint bottomRightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2 - 1];
            uint256[4] memory bottomRightCardValues = numberToCard(bottomRightCard);
            uint topLeftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2];
            uint256[4] memory topLeftCardValues = numberToCard(topLeftCard);
            uint topRightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint256[4] memory topRightCardValues = numberToCard(topRightCard);
            return bottomLeftCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_LEFT] && bottomRightCardValues[TOP_LEFT] == targetCardValues[BOTTOM_RIGHT] && topLeftCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_LEFT] && topRightCardValues[BOTTOM_LEFT] == targetCardValues[TOP_RIGHT];
        } else if (guessCoordinates[COLUMN] % 2 == 1 && guessCoordinates[ROW] % 2 == 0) {
            // 2 cards
            uint bottomCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2 - 1];
            uint256[4] memory bottomCardValues = numberToCard(bottomCard);
            uint topCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint256[4] memory topCardValues = numberToCard(topCard);
            return bottomCardValues[TOP_LEFT] == targetCardValues[BOTTOM_LEFT] && bottomCardValues[TOP_RIGHT] == targetCardValues[BOTTOM_RIGHT] && topCardValues[BOTTOM_LEFT] == targetCardValues[TOP_LEFT] && topCardValues[BOTTOM_RIGHT] == targetCardValues[TOP_RIGHT];
        } else {
            // 2 cards
            uint leftCard = board[guessCoordinates[COLUMN] / 2 - 1][guessCoordinates[ROW] / 2];
            uint256[4] memory leftCardValues = numberToCard(leftCard);
            uint rightCard = board[guessCoordinates[COLUMN] / 2][guessCoordinates[ROW] / 2];
            uint256[4] memory rightCardValues = numberToCard(rightCard);
            return leftCardValues[BOTTOM_RIGHT] == targetCardValues[BOTTOM_LEFT] && rightCardValues[BOTTOM_LEFT] == targetCardValues[BOTTOM_RIGHT] && leftCardValues[TOP_RIGHT] == targetCardValues[TOP_LEFT] && rightCardValues[TOP_LEFT] == targetCardValues[TOP_RIGHT];
        }
    }

    // Maps the 4 values of the card to a single number (0 to 255)
    function cardToNumber(uint256[4] memory cardValues) private pure returns (uint256) {
        require(cardValues.length == 4, "Card must have exactly 4 values.");
        uint256 result = 0;
        for (uint256 i = 0; i < 4; i++) {
            require(cardValues[i] < 4, "Each value must be between 0 and 3.");
            result += cardValues[i] * uint256(4**i);
        }
        return result;
    }

    // Maps a number (0 to 255) back to the 4 values of the card
    function numberToCard(uint256 number) private pure returns (uint256[4] memory) {
        require(number < 256, "Number must be between 0 and 255.");
        uint256[4] memory cardValues;
        for (uint256 i = 0; i < 4; i++) {
            cardValues[i] = number % 4;
            number /= 4;
        }
        return cardValues;
    }
    
    function generatePermutation(uint256 seed) public pure returns (uint256[BOARD_WIDTH][BOARD_WIDTH] memory board) {
        uint256[NUM_CARDS] memory permutation;
        for (uint256 i = 0; i < NUM_CARDS; i++) {
            permutation[i] = i;
        }
        for (uint256 i = NUM_CARDS - 1; i > 0; i--) {
            uint256 j = random(seed, i + 1);
            (permutation[i], permutation[j]) = (permutation[j], permutation[i]);
            seed = uint256(keccak256(abi.encodePacked(seed, i)));
        }
        for (uint256 i = 0; i < BOARD_WIDTH; i++) {
            for (uint256 j = 0; j < BOARD_WIDTH; j++) {
                board[i][j] = permutation[i*BOARD_WIDTH + j];
            }
        }
    }

    function random(uint256 seed, uint256 upperBound) private pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed))) % upperBound;
    }
}
