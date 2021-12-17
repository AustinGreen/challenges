import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('DiamondHands', function () {
  it("Should return the new greeting once it's changed", async function () {
    const DiamondHands = await ethers.getContractFactory('DiamondHands')
    const diamondHands = await DiamondHands.deploy()
    await diamondHands.deployed()

    const [owner] = await ethers.getSigners()

    await diamondHands.deposit({
      value: ethers.utils.parseEther('1.0'),
    })

    expect(await diamondHands.balanceOf(owner.address)).to.equal(ethers.utils.parseEther('1.0'))

    // const setGreetingTx = await greeter.setGreeting('Hola, mundo!')

    // // wait until the transaction is mined
    // await setGreetingTx.wait()

    // expect(await greeter.greet()).to.equal('Hola, mundo!')
  })
})
