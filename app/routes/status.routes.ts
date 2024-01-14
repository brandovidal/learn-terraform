import type { Request, Response, Router } from 'express'
import httpStatus from 'http-status'

function register (router: Router) {
  router.get('/status', (_req: Request, res: Response) => {
    const body = {
      success: true,
      message: 'Health check retrieved successfully',
      data: []
    }

    res.status(httpStatus.OK).send({
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify(body, null, 2)
    })
  })
}

export default register
