const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
  ["Leo", "Tom", "Brad"],  // Names
  ["https://i.imgur.com/pKd5Sdk.png", // Images
  "https://i.imgur.com/xVu4vFL.png", 
  "https://i.imgur.com/WMB6g9u.png"],
  [100, 200, 300],  // HP Values
  [100, 50, 25]     // Attack damage values
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();