/**
 * 
 * 
 */

// @ts-check

'use strict'

const config = {
    // @ts-ignore
    mode: ( process.env.NODE_ENV === 'production' ) && 'PROD' || 'DEV',
    bot: {
        // @ts-ignore
        apikey: process.env.TBOT_AUTHTOKEN
    }
}

module.exports = { config }