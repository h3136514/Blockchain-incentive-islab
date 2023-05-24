const GBUPoint = artifacts.require("GBUPoint");
const chai = require("chai");
const BN = web3.utils.BN;
chai.use(require("chai-bn")(BN));
const { expect } = chai;

contract.only("Test2", (accounts) => {
  it("Should not have zero address", async () => {
    const gbupointInstance = await GBUPoint.deployed();
    await expect(gbupointInstance.address).to.not.equal(0x0);
  });
});
