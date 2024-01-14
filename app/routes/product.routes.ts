import type { Request, Response, Router } from 'express'
import httpStatus from 'http-status'

let products: any[] = []

function register (router: Router) {
  router.get('/products', (_req: Request, res: Response) => {
    const data = products
    res.status(httpStatus.OK).send({
      statusCode: httpStatus.OK,
      success: true,
      message: 'products retrieved successfully',
      data
    })
  })

  router.post('/product', (req: Request, res: Response) => {
    const { name = 'test', price = 0 } = req.body

    const transaction = {
      id: products.length + 1,
      name,
      price
    }
    products.push(transaction)

    res.status(httpStatus.CREATED).send({
      statusCode: httpStatus.CREATED,
      success: true,
      message: 'Transaction created successfully',
      data: transaction
    })
  })
}

export default register
