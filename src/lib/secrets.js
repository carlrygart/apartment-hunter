import { SSM } from 'aws-sdk'
import { memoize } from 'lodash'

const ssm = new SSM()

export const getSecret = memoize(async key => {
  return (
    await ssm
      .getParameter({
        Name: key,
        WithDecryption: true,
      })
      .promise()
  ).Parameter.Value
})
