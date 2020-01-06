const esmRequire = require('esm')(module)
const { handler } = esmRequire('../src/handler')

describe('handler', () => {
  test('runs', async () => {
    const a = await handler()
    expect(a).toEqual(1)
  })
})
