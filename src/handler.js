import forge from 'mappersmith'
import { createTransport } from 'nodemailer'
import { getSecret } from './lib/secrets'
import { exists, add } from './lib/repository'

const sthlmBostad = forge({
  clientId: 'SthlmBostad',
  host: 'https://bostad.stockholm.se',
  resources: {
    Annonser: {
      all: { path: '/Lista/AllaAnnonser' },
    },
  },
})

export const handler = async (event, context) => {
  const allApartments = (await sthlmBostad.Annonser.all()).data()
  const bostadsSnabben = allApartments.filter(apartment => apartment.Bostadssnabben === true)
  console.log(`Found ${bostadsSnabben.length} apartments`, bostadsSnabben)
  if (!bostadsSnabben) return

  const newApartments = []
  for (let apartment of bostadsSnabben) {
    if (await exists(apartment.AnnonsId)) {
      console.log('Already sent email about', apartment.AnnonsId)
    } else {
      newApartments.push(apartment)
    }
  }

  const mailer = createTransport({
    host: 'smtp.eu.mailgun.org',
    port: 465,
    secure: true,
    auth: {
      user: await getSecret('apartment-hunter.email.username'),
      pass: await getSecret('apartment-hunter.email.password'),
    },
  })

  await Promise.all(
    newApartments.map(async apartment => {
      await mailer.sendMail({
        to: 'your@email.com',
        subject: `Hittat en bostad - ${apartment.Gatuadress}`,
        text: `https://bostad.stockholm.se/${apartment.Url}`,
      })
      console.log('Email sent, will store apartment in DB', apartment.AnnonsId)
      await add(apartment)
    })
  )
}
