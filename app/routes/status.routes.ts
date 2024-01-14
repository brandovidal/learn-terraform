import type { Request, Response, Router } from 'express'
import httpStatus from 'http-status'

function register (router: Router) {
  router.get('/status', (_req: Request, res: Response) => {
    res.status(httpStatus.OK).send({
      success: true,
      statusCode: 200,
      message: 'Health check retrieved successfully',
      data: []
    })
  })
}

export default register
