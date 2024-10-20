/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  31337: {
    QuestionMarkGame: {
      address: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
      abi: [
        {
          inputs: [
            {
              internalType: "uint256[4]",
              name: "cardValues",
              type: "uint256[4]",
            },
          ],
          name: "cardToNumber",
          outputs: [
            {
              internalType: "uint256",
              name: "",
              type: "uint256",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "claimWin",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
          ],
          name: "generatePermutation",
          outputs: [
            {
              internalType: "uint256[3][3]",
              name: "board",
              type: "uint256[3][3]",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "seed",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "targetCard",
              type: "uint256",
            },
            {
              internalType: "uint256[2]",
              name: "guessCoordinates",
              type: "uint256[2]",
            },
          ],
          name: "guess",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256[3][3]",
              name: "board",
              type: "uint256[3][3]",
            },
            {
              internalType: "uint256",
              name: "targetCard",
              type: "uint256",
            },
            {
              internalType: "uint256[2]",
              name: "guessCoordinates",
              type: "uint256[2]",
            },
          ],
          name: "isGuessCorrect",
          outputs: [
            {
              internalType: "bool",
              name: "",
              type: "bool",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
        {
          inputs: [
            {
              internalType: "uint256",
              name: "number",
              type: "uint256",
            },
          ],
          name: "numberToCard",
          outputs: [
            {
              internalType: "uint256[4]",
              name: "",
              type: "uint256[4]",
            },
          ],
          stateMutability: "pure",
          type: "function",
        },
      ],
      inheritedFunctions: {},
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
