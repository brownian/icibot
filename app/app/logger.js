/**
 * 
 */

// @ts-check

'use strict'

const winston = require('winston')
const { config } = require('./config')

const myFormat = winston.format.combine(
    winston.format.timestamp({
        format: 'YYYY-MM-DD HH:mm:ss'
    }),
    winston.format.splat(),
    // winston.format.simple(),
    winston.format.printf(info => `${[info.timestamp]}: ${info.level.toUpperCase()}: ${info.label}: ${info.message}`)
    // winston.format.printf(info => `${[info.timestamp]}: ${info.level.toUpperCase()}: ${info.message}`)
)

const logger = winston.createLogger({
    level: 'debug',
    format: myFormat,
    // defaultMeta: { service: 'user-service' },
    transports: [
        //
        // - Write all logs with importance level of `error` or less to `error.log`
        // - Write all logs with importance level of `info` or less to `combined.log`
        //
        new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
        new winston.transports.File({ filename: 'logs/combined.log' }),
    ],
    exceptionHandlers: [
        new winston.transports.File({ filename: 'logs/exceptions.log' })
    ]
})

//
// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest }) `
//
if ( config.mode !== 'PROD' ) {
    logger.add(new winston.transports.Console({ format: myFormat }))
}

logger.exitOnError = false

module.exports = { logger }

// logger.debug('Message')
