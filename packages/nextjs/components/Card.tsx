import Image from 'next/image';

type CardProps = {
  digits: number[]; // Array of 4 digits between 0 and 3
};

const Card: React.FC<CardProps> = ({ digits }) => {
  // Map each digit to an image path
  const imagePaths = digits.map((digit) => `/images/${digit}1.jpg`);

  return (
    <div className="card">
      <div className="card-row">
        <Image src={imagePaths[3]} alt="" width={50} height={50} />
        <Image src={imagePaths[2]} alt="" width={50} height={50} />
      </div>
      <div className="card-row">
        <Image src={imagePaths[1]} alt="" width={50} height={50} />
        <Image src={imagePaths[0]} alt="" width={50} height={50} />
      </div>
    </div>
  );
};

export default Card;
