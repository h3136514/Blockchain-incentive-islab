const GBUPoint = artifacts.require("GBUPoint");

contract("Test1", (accounts) => {
  it("Should not have zero address", async () => {
    const gbupointInstance = await GBUPoint.deployed();
    console.log(gbupointInstance);
    await assert.notEqual(gbupointInstance.address, 0x0);
  });

  it("Point Name is GBU ", async () => {
    const gbupointInstance = await GBUPoint.deployed();
    const result = await gbupointInstance.Get_Point_Name();
    await assert.equal(result, "GBU");
  });

  it("Point Symbol is Point ", async () => {
    const gbupointInstance = await GBUPoint.deployed();
    const result = await gbupointInstance.Get_Point_Symbol();
    await assert.equal(result, "Point");
  });
});
