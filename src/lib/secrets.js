import { SSM } from 'aws-sdk'

const ssm = new SSM()

export const getSecret = async key => {
  return (
    await ssm
      .getParameter({
        Name: key,
        WithDecryption: true,
      })
      .promise()
  ).Parameter.Value
}
