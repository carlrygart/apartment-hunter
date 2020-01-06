import { DynamoDB } from 'aws-sdk'

const DB = new DynamoDB()

const createDBApartmentItem = apartment => ({
  AnnonsId: { N: apartment.AnnonsId.toString() },
  Stadsdel: { S: apartment.Stadsdel },
  Gatuadress: { S: apartment.Gatuadress },
  Kommun: { S: apartment.Kommun },
  Vaning: { N: apartment.Vaning.toString() },
  AntalRum: { N: apartment.AntalRum.toString() },
  Yta: { N: apartment.Yta.toString() },
  Hyra: { N: apartment.Hyra.toString() },
})

export const exists = async annonsId => {
  const res = await DB.getItem({
    Key: {
      AnnonsId: {
        N: annonsId.toString(),
      },
    },
    TableName: 'emailed_apartments',
  }).promise()

  return !!res.Item
}

export const add = async apartment => {
  return await DB.putItem({
    Item: createDBApartmentItem(apartment),
    TableName: 'emailed_apartments',
  }).promise()
}
