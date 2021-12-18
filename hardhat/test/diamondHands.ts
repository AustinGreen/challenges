import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('DiamondHands', function () {
  it('should accept deposits', async function () {
    const DiamondHands = await ethers.getContractFactory('DiamondHands')
    const diamondHands = await DiamondHands.deploy()
    await diamondHands.deployed()

    const [owner] = await ethers.getSigners()

    const depositValue = await diamondHands.deposit({
      value: ethers.utils.parseEther('1.0'),
    })

    await depositValue.wait()

    expect(await diamondHands.balanceOf(owner.address)).to.equal(ethers.utils.parseEther('1.0'))
  })
})
