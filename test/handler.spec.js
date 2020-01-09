const esmRequire = require('esm')(module)
const { handler } = esmRequire('../src/handler')

// TODO: Write proper tests
describe('handler', () => {
  test('runs', async () => {
    // const a = await handler()
    expect(1).toEqual(1)
  })
})
