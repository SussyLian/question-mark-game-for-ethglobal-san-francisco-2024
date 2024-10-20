"use client";

import { useParams } from 'next/navigation';
import { useScaffoldReadContract } from '~~/hooks/scaffold-eth';
import { useEffect, useState } from 'react';
import Card from '../../../components/Card'; // Adjust path to Card component

const PlayRoute = () => {
  const { seed } = useParams();

  const seedString = Array.isArray(seed) ? seed[0] : seed;
  const seedNumber = seedString ? BigInt(seedString) : undefined;

  const { data: boardData, isLoading } = useScaffoldReadContract({
    contractName: "QuestionMarkGame",
    functionName: "generatePermutation",
    args: [seedNumber],
  });

  const [processedBoard, setProcessedBoard] = useState<number[][][]>([]);
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [closestButton, setClosestButton] = useState<number | null>(null);

  useEffect(() => {
    if (boardData && !isLoading) {
      const board = boardData as unknown as readonly bigint[][];
      const processed = board.map((row) =>
        row.map((cardNumber) => convertToBase4(Number(cardNumber)))
      );
      setProcessedBoard(processed);
    }
  }, [boardData, isLoading]);

  const convertToBase4 = (num: number): number[] => {
    const digits = [];
    for (let i = 3; i >= 0; i--) {
      const divisor = Math.pow(4, i);
      const digit = Math.floor(num / divisor);
      digits.push(digit);
      num %= divisor;
    }
    return digits;
  };

  // Track mouse position
  const handleMouseMove = (event: React.MouseEvent<HTMLDivElement>) => {
    setMousePosition({ x: event.clientX, y: event.clientY });
    calculateClosestButton(event.clientX, event.clientY);
  };

  // Function to calculate which button is closest to the mouse
  const calculateClosestButton = (mouseX: number, mouseY: number) => {
    const buttonPositions = getButtonPositions(); // Get the button positions dynamically
    let closestIdx = null;
    let minDistance = Infinity;
    // console.log('mouseX,mouseY', mouseX, mouseY);
    buttonPositions.forEach((pos, idx) => {
      const distance = Math.sqrt(
        Math.pow(mouseX - pos.x, 2) + Math.pow(mouseY - pos.y, 2)
      );
      // console.log('distance', pos, idx, distance);
      if (distance < minDistance) {
        minDistance = distance;
        closestIdx = idx;
      }
    });

    setClosestButton(closestIdx);
  };

  const getButtonPositions = () => {
    // Calculate button positions based on the grid and return an array of positions
    const positions = [];
    const gridSize = 100; // Assuming each card is 100px x 100px

    processedBoard.forEach((row, rowIndex) => {

      if (rowIndex == 0) {
        row.forEach((_, colIndex) => {
          if (colIndex < row.length - 1) {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
              {
                x: gridSize * (colIndex + 1),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          } else {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          }
        });
      } else {
        row.forEach((_, colIndex) => {
          if (colIndex < row.length - 1) {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 1),
              },
              {
                x: gridSize * (colIndex + 1),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 1),
              },
            );
          } else {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 1),
              },
            );
          }
        });
        row.forEach((_, colIndex) => {
          if (colIndex < row.length - 1) {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
              {
                x: gridSize * (colIndex + 1),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          } else {
            positions.push(
              {
                x: gridSize * (colIndex + 0.5),
                y: gridSize * ((processedBoard.length - 1 - rowIndex) + 0.5),
              },
            );
          }
        });
      }
    });

    // console.log('positions', positions);

    return positions;
  };

  if (isLoading || !processedBoard.length) {
    return <p>Loading board...</p>;
  }

  return (
    <div onMouseMove={handleMouseMove} className="board-container">
      {/* <h1>Game Board for Seed: {seedString}</h1> */}
      <div className="board">
        {processedBoard.map((row, rowIndex) => (
          <div className="board-row" key={rowIndex}>
            {row.map((cardDigits, colIndex) => (
              <Card key={`${rowIndex}-${colIndex}`} digits={cardDigits} />
            ))}
          </div>
        ))}
      </div>
      <div className="buttons-layer">
        {getButtonPositions().map((pos, idx) => (
          <button
            key={idx}
            className={`circle-button ${idx === closestButton ? 'visible' : 'hidden'}`}
            style={{ left: pos.x, top: pos.y }}
          />
        ))}
      </div>
    </div>
  );
};

export default PlayRoute;
